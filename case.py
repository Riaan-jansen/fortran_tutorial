'''script to read file and return same file in all caps or lower case.
-> python3 case.py <pathToFile> <TrueForCaps> -> output is new file,
COPY_<oldFileName> .'''
import argparse

def newCaps(fpath: str):
    '''takes filepath, reads line by line, converts
    to upper case, writes new file'''
    outpath = 'COPY_' + fpath.upper()
    try:
        with open(fpath) as ifile:
            with open(outpath, 'w') as ofile:
                for line in ifile:
                    new_line = line.upper()
                    ofile.write(new_line)
    except FileExistsError:
        print('File already exists')
    return None


def allCaps(fpath: str):
    '''takes filepath, rewrites in all caps.'''
    try:
        with open(fpath, 'r') as f:
            file = f.read()
            file = file.upper()
        with open(fpath, 'w') as f:
            for line in file:
                f.write(line)
    except OSError:
        print(f'OS error trying to open {fpath}')


def noCaps(fpath: str):
    '''takes filepath, rewrites in all lower case.'''
    try:
        with open(fpath, 'r') as f:
            file = f.read()
            file = file.lower()
        with open(fpath, 'w') as f:
            for line in file:
                f.write(line)
    except OSError:
        print(f'OS error trying to open {fpath}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='''
                                     script to convert a file
                                     to all caps.''', add_help=False)
    parser.add_argument('-h', '--help', action='help', help='''to execute:
                        python3 case.py <ifile> -a <int>.''')
    parser.add_argument('ifile', type=str, help='name / path to file')
    parser.add_argument('-a', '--action', nargs='?', type=int, default=1,
                        help='Do allCaps or noCaps: >0 all, <0 no.')

    args = parser.parse_args()
    if args.action >= 0:
        allCaps(args.ifile)
    if args.action <= 0:
        noCaps(args.ifile)
