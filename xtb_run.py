import os
import sys
import json

errFiles = []


def getCurrentDirectory():
    # use current directory
    try:
        basedir = sys.argv[1]
    except IndexError:
        print('using file location as basedir')
        basedir = os.path.dirname(os.path.realpath(__file__))
    print(basedir)
    return basedir


def moveFiles(currdir, basedir):
    print('moving files')
    os.chdir(currdir)
    count = 0
    for dir in os.listdir():
        if(os.path.isfile(dir) and dir[0] != '.'):
            dirsplit = os.path.splitext(dir)
            dirname = dirsplit[0]
            dirext = dirsplit[1]
            if(dirext == '.xyz'):
                try:
                    os.mkdir(dirname)
                except:
                    pass
                os.system('mv -- \"' + dirname + '.xyz\" \"' +
                          dirname + '/' + dirname + '.xyz\"')
                count += 1
    print('moved', count, 'files')
    os.chdir(basedir)


def do_xtb(dir, currdir):
    os.chdir(currdir)
    if(os.path.isdir(dir) and dir[0] != '.'):
        if(os.path.isfile(os.path.join(currdir, dir, 'xtbopt.xyz'))):
            print("xtb opt already exists...")
            recompute = False
            os.chdir(dir)
        else:
            recompute = True
            os.chdir(dir)

        chrg = '0'
        if(recompute):
            print('checking charge')
            os.system('xtb ./\"' + dir + ".xyz\" > output_xtb_setup.out")
            with open('output_xtb_setup.out', 'r') as file:
                data = file.readlines()
            for line in data:
                if('spin                       :                   0.5' in line):
                    chrg = '1'

        if(recompute):
            print('calculating triplet')
            os.system("xtb ./\"" + dir +
                      ".xyz\" --opt tight --gfn 2 --chrg " + chrg + " --uhf 2 --gbsa acetonitrile > output_xtb_trip.out")
            if(not os.path.isfile(os.path.join(currdir, dir, 'xtbopt.xyz'))):
                os.system("xtb ./\"" + dir +
                          ".xyz\" --opt tight --gfn 1 --chrg " + chrg + " --uhf 2 --gbsa acetonitrile > output_xtb_trip.out")
            os.system(
                "grep 'TOTAL ENERGY' output_xtb_trip.out > T1ExXTB.dat")

        with open(os.path.join(currdir, dir, 'T1ExXTB.dat')) as data:
            datastr = data.read()
            temp = datastr.split()
            try:
                T1En_xtb = float(temp[3])
            except IndexError:
                if dir not in errFiles:
                    errFiles.append(dir)
                print(dir)
                T1En_xtb = None
            except ValueError:
                if dir not in errFiles:
                    errFiles.append(dir)
                print(dir)
                T1En_xtb = None

        if(recompute):
            print('calculating ground')
            os.system("xtb ./\"" + dir +
                      ".xyz\" --opt tight --gfn 2 --chrg " + chrg + " --gbsa acetonitrile > output_xtb.out")
            if(not os.path.isfile(os.path.join(currdir, dir, 'xtbopt.xyz'))):
                os.system("xtb ./\"" + dir +
                          ".xyz\" --opt tight --gfn 1 --chrg " + chrg + " --gbsa acetonitrile > output_xtb.out")
            os.system("grep 'TOTAL ENERGY' output_xtb.out > S0XTB.dat")

        with open(os.path.join(currdir, dir, 'S0XTB.dat')) as data:
            datastr = data.read()
            temp = datastr.split()
            try:
                S0En_xtb = float(temp[3])
            except IndexError:
                if dir not in errFiles:
                    errFiles.append(dir)
                S0En_xtb = None
            except ValueError:
                if dir not in errFiles:
                    errFiles.append(dir)
                S0En_xtb = None
        try:
            T1Ex_xtb = (T1En_xtb - S0En_xtb) * 27.2114
        except TypeError:
            if dir not in errFiles:
                errFiles.append(dir)
            T1Ex_xtb = None
    else:
        T1En_xtb = None
        S0En_xtb = None
        T1Ex_xtb = None
    return T1En_xtb, S0En_xtb, T1Ex_xtb


def run_xtb(xyzdir, basedir):
    os.chdir(xyzdir)
    count = 0
    exData = {}
    listdirs = []
    for dir in sorted(os.listdir()):
        if os.path.isdir(dir) and dir[0] != '.':
            listdirs.append(dir)
    print('starting xtb for ground and triplet')
    for index, dir in enumerate(listdirs):
        print('  ' + str(index + 1) + ' / ' + str(len(listdirs)))

        T1En_xtb, S0En_xtb, T1Ex_xtb = do_xtb(dir, xyzdir)
        if(T1Ex_xtb is not None):
            exData[dir] = {}
            exData[dir]["orig"] = {}
            exData[dir]["orig"]["T1"] = T1Ex_xtb
        else:
            errFiles.append(dir)
        if(T1Ex_xtb < 1e-3 or T1Ex_xtb > 10):
            errFiles.append(dir)

        os.chdir(basedir)
        with open('exData.txt', 'w') as file:
            json.dump(exData, file)
        with open('exData_errs.txt', 'w') as file:
            json.dump(errFiles, file)
        with open('startInd_xtb.txt', 'w') as file:
            file.write(str(index))
        os.chdir(xyzdir)
    os.chdir(basedir)
    return exData


def do_stda(dir, currdir):
    os.chdir(currdir)
    os.chdir(dir)
    print('setting up for stda')
    os.system("xtb4stda xtbopt.xyz -gbsa acetonitrile > output_xtb4stda.out")
    print('running stda')
    os.system("stda -xtb -e 10 > output_stda.out")  # stda
    os.system("grep -A1 state output_stda.out | tail -1 > S1Ex.dat")
    with open('S1Ex.dat') as data:
        datastr = data.read()
        temp = datastr.split()
        S1En_stda = float(temp[1])
    print('running stddft')
    os.system("stda -xtb -e 10 -rpa > output_stddft.out")  # stddft
    os.system("grep -A1 state output_stddft.out | tail -1 > S1Ex_tddft.dat")
    with open('S1Ex_tddft.dat') as data:
        datastr = data.read()
        temp = datastr.split()
        try:
            S1En_stddft = float(temp[1])
        except:
            S1En_stddft = None
    return S1En_stda, S1En_stddft


def run_stda(xyzdir, basedir):
    count = 0
    os.chdir(basedir)
    with open('exData.txt', 'r') as file:
        exData = json.load(file)
    os.chdir(xyzdir)
    listdirs = []
    for dir in sorted(os.listdir()):
        if os.path.isdir(dir) and dir[0] != '.':
            listdirs.append(dir)
    print('starting stda for first excited singlet')
    for index, dir in enumerate(listdirs):
        print('  ' + str(index + 1) + ' / ' + str(len(listdirs)))
        os.chdir(dir)
        if(os.path.isfile('wfn.xtb')):
            with open('S1Ex.dat', 'r') as data:
                datastr = data.read()
                temp = datastr.split()
                S1En_stda = float(temp[1])
            with open('S1Ex_tddft.dat', 'r') as data:
                datastr = data.read()
                temp = datastr.split()
                try:
                    S1En_stddft = float(temp[1])
                except:
                    S1En_stddft = None
        else:
            S1En_stda, S1En_stddft = do_stda(dir, xyzdir)

        if(S1En_stda is not None):
            exData[dir]["orig"]["S1_stda"] = S1En_stda
            exData[dir]["orig"]["S1_stddft"] = S1En_stddft
        else:
            errFiles.append(dir)
        if(S1En_stda < 1e-3 or S1En_stda > 10):
            errFiles.append(dir)

        os.chdir(basedir)
        with open('exData.txt', 'w') as file:
            json.dump(exData, file)
        with open('exData_errs.txt', 'w') as file:
            json.dump(errFiles, file)
        with open('startInd_stda.txt', 'w') as file:
            file.write(str(index))
        os.chdir(xyzdir)
    os.chdir(basedir)
    return exData


def main():
    basedir = getCurrentDirectory()
    xyzdir = os.path.join(basedir, 'molxyzfiles')
    moveFiles(xyzdir, basedir)
    exData = run_xtb(xyzdir, basedir)
    exData = run_stda(xyzdir, basedir)
    print('succesfully completed')


if __name__ == '__main__':
    main()
