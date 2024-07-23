import matplotlib.pyplot as plt

def read(file):
    energy = []
    xs = []
    with open(file, 'r') as f:
        for line in f:
            line = line.split()
            energy.append(line[0])
            xs.append(line[1])
    return energy, xs


def compare(file1, file2):
    li_e, li_xs = read(file1)
    be_e, be_xs = read(file2)

    plt.plot(li_e, li_xs, label='li')
    plt.plot(be_e, be_xs, label='be')
    plt.show()


compare('li_data.txt', 'be_data.txt')

