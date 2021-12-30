########## IMAN ALI ##########
########## imaali ##############
########## 112204305 #############
import re
import os


def rename(path):
    if not os.path.exists(path):
        return path + " does not exist!"

    a = -1

    for filename in sorted(os.listdir(path)):
        if os.path.isfile(os.path.join(path, filename)):
            if not snap_format(filename):
                continue

            if a == -1:
                a = int(filename[4:7]) + 1
                continue
            elif int(filename[4:7]) == a:
                a += 1
                continue
            else:
                new_name = "snap"
                new_name += str(a // 100)
                new_name += str(a // 10**1 % 10)
                new_name += str(a % 10)
                new_name += ".txt"
                a += 1

                if os.path.isdir(os.path.join(path, new_name)):
                    raise ValueError

                os.rename(os.path.join(path, filename), os.path.join(path, new_name))


def snap_format(name):
    # if file has the snap pattern snapxxx.txt (start and end)
    if not (name.endswith(".txt") and name.startswith("snap")):
        return False

    # Wrong length
    if not len(name) == 11:
        return False

    # if file has the snap pattern snapxxx.txt (digits)
    for digit in range(4, 7):
        if not (name[digit].isdigit()):
            return False

    return True
