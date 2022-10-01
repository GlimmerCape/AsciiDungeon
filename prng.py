def prng(m, x0, a, c):
    return (a * x0 + c) % m

def prngSeq(m, x0, a, c, seqLength):
    seq = list()
    for i in range(seqLength):
        seq.append(x0)
        x0 = prng(m, x0, a, c)
    return seq

while(True):
    m = int(input("Input modulus: "))
    a = int(input("Input multiplier: "))
    c = int(input("Input increment: "))
    x0 = int(input("Input seed: "))
    seqLength= int(input("Sequence length: "))

    rngList = prngSeq(m, x0, a, c, seqLength)
    for n in rngList:
        print(n)

