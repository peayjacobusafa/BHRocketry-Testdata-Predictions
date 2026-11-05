#!/usr/bin/env python3
"""
Convert a NASA CEA rocket-problem output file (.out / .txt) to a CSV.

Usage:
     python cea_to_csv.py my_case.out
     python cea_to_csv.py my_case.out -o results.csv
 
 Output: one row per (chamber pressure, O/F, station).
"""
import argparse
import csv
import os
import re

# ---------- number parsing ----------
NUM_RE = re.compile(r'^[-+]?(\d+\.?\d*|\.\d+)([eE][-+]?\d+)?$')
# CEA often writes small numbers Fortran-style, e.g. 1.2345-3 meaning 1.2345e-3
FORTRAN_RE = re.compile(r'^([-+]?(?:\d+\.\d*|\.\d+))([-+]\d+)$')


def to_float(tok):
    if NUM_RE.match(tok):
        return float(tok)
    m = FORTRAN_RE.match(tok)
    if m:
        return float(m.group(1) + 'e' + m.group(2))
    return None


def split_row(line):
    "Split 'LABEL  1.0 2.0 3.0' into ('LABEL', [1.0, 2.0, 3.0])."
    tokens = line.split()
    values = []
    while tokens and to_float(tokens[-1]) is not None:
        values.insert(0, to_float(tokens.pop()))
    return ' '.join(tokens), values


# ---------- column naming (MATLAB-friendly) ----------
RENAME = {
    'PINF/P': 'Pinf_over_P', 'PIN/P': 'Pin_over_P',
    'P, BAR': 'P_bar', 'T, K': 'T_K',
    'RHO, KG/CU M': 'RHO_kgm3',
    'H, KJ/KG': 'H_kJkg', 'U, KJ/KG': 'U_kJkg', 'G, KJ/KG': 'G_kJkg',
    'S, KJ/(KG)(K)': 'S_kJkgK',
    'M, (1/N)': 'MW_gmol', 'MW, MOL WT': 'MW_gmol',
    '(DLV/DLP)T': 'dLVdLP_t', '(DLV/DLT)P': 'dLVdLT_p',
    'CP, KJ/(KG)(K)': 'Cp_kJkgK', 'GAMMAS': 'gamma_s',
    'SON VEL,M/SEC': 'sonvel_ms', 'MACH NUMBER': 'Mach',
    'AE/AT': 'Ae_At', 'CSTAR, M/SEC': 'cstar_ms', 'CF': 'CF',
    'IVAC, M/SEC': 'Ivac_ms', 'ISP, M/SEC': 'Isp_ms',
}


def clean_name(label):
    key = ' '.join(label.split()).upper()
    if key in RENAME:
        return RENAME[key]
    return re.sub(r'\W+', '_', label).strip('_')


# ---------- parser ----------
def parse(path):
    blocks = []              # finished O/F blocks
    cur = None               # block being built
    stations = []
    mode = None              # None, 'props', 'perf', 'mole'
    model, case = '', ''
    warned = set()

    def finish():
        nonlocal cur
        if cur is not None:
            blocks.append(cur)
        cur = None

    with open(path, 'r', errors='replace') as f:
        for raw in f:
            line = raw.rstrip('\n')
            s = line.strip()
            if not s:
                continue

            if 'THEORETICAL ROCKET PERFORMANCE' in s:
                finish()
                mode = None
                model = 'FROZEN' if 'FROZEN' in s else 'EQUILIBRIUM'
                continue

            m = re.search(r'CASE\s*=\s*(\S.*)?', s)
            if m and mode is None:
                case = (m.group(1) or '').strip()

            if s.startswith('O/F='):
                finish()
                meta = {'case': case, 'model': model}
                for key, pat in (('OF', r'O/F=\s*([-\d.]+)'),
                                 ('pct_fuel', r'%FUEL=\s*([-\d.]+)'),
                                 ('r_eq_ratio', r'R,EQ\.RATIO=\s*([-\d.]+)'),
                                 ('phi_eq_ratio', r'PHI,EQ\.RATIO=\s*([-\d.]+)')):
                    mm = re.search(pat, s)
                    meta[key] = float(mm.group(1)) if mm else ''
                cur = {'meta': meta, 'data': {}, 'Pc': ''}
                stations = []
                mode = 'props'
                continue

            if cur is None:
                continue

            # station header, e.g.  CHAMBER   THROAT     EXIT
            if 'THROAT' in s and 'CHAMBER' in s or ('THROAT' in s and 'EXIT' in s):
                names = s.replace('COMB END', 'COMB_END').split()
                counts = {}
                stations = []
                for n in names:
                    counts[n] = counts.get(n, 0) + 1
                for n in names:
                    stations.append(n)
                dup = [n for n in set(names) if names.count(n) > 1]
                if dup:
                    seen = {}
                    stations = []
                    for n in names:
                        seen[n] = seen.get(n, 0) + 1
                        stations.append(f'{n}{seen[n]}' if n in dup else n)
                continue

            if 'PERFORMANCE PARAMETERS' in s:
                mode = 'perf'
                continue
            if s.startswith('MOLE FRACTIONS'):
                mode = 'mole'
                continue
            if s.startswith('* THERMODYNAMIC') or s.startswith('PRODUCTS WHICH'):
                mode = None
                continue
            if mode is None:
                continue

            label, values = split_row(s)
            if not values or not label:
                continue

            if mode == 'mole':
                col = 'x_' + clean_name(label.lstrip('*'))
            else:
                col = clean_name(label)

            n = len(values)
            if mode in ('props', 'mole') and n != len(stations):
                if n > len(stations):
                    stations = stations + [f'STATION{i}' for i in range(len(stations), n)]
                elif mode == 'mole':
                    if label not in warned:
                        print(f'  warning: skipped {label} (found {n} values, '
                              f'expected {len(stations)})')
                        warned.add(label)
                    continue
            # performance rows (Ae/At, CSTAR, CF, Isp...) are listed from the
            # throat onward, so align them to the LAST n stations
            target = stations[-n:]
            for st, v in zip(target, values):
                cur['data'].setdefault(st, {})[col] = v

            if mode == 'props' and label.upper().startswith('P,') and not cur['Pc']:
                cur['Pc'] = values[0]   # chamber pressure, in the file's units

    finish()
    return blocks


def main():
    ap = argparse.ArgumentParser(description='Convert CEA rocket output to CSV')
    ap.add_argument('infile')
    ap.add_argument('-o', '--outfile', default=None)
    args = ap.parse_args()
    out = args.outfile or os.path.splitext(args.infile)[0] + '.csv'

    blocks = parse(args.infile)
    if not blocks:
        print('No O/F blocks found. Is this a CEA rocket-problem output file?')
        return

    rows = []
    for b in blocks:
        for st, d in b['data'].items():
            row = dict(b['meta'])
            row['Pc'] = b['Pc']
            row['station'] = st
            row.update(d)
            if 'Isp_ms' in row:
                row['Isp_s'] = row['Isp_ms'] / 9.80665
            if 'Ivac_ms' in row:
                row['Ivac_s'] = row['Ivac_ms'] / 9.80665
            rows.append(row)

    first = ['case', 'model', 'Pc', 'OF', 'pct_fuel', 'r_eq_ratio',
             'phi_eq_ratio', 'station']
    others, species = [], []
    for r in rows:
        for k in r:
            if k in first:
                continue
            lst = species if k.startswith('x_') else others
            if k not in lst:
                lst.append(k)
    fields = first + others + species

    with open(out, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=fields, restval='')
        w.writeheader()
        w.writerows(rows)

    print(f'Parsed {len(blocks)} O/F blocks -> {len(rows)} rows, '
          f'{len(fields)} columns')
    print(f'Wrote {out}')


if __name__ == '__main__':
    main()
