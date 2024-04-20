class Tree:

    def __init__(self, left_val, right_val, current_val):

        # left, right, current is either a number or character
        # bottom nodes will have a current value which is the character at that spot
        # if the current is a character than the left and right will be None
        self.left = left_val
        self.right = right_val
        self.current = current_val

    def get_current(self): return self.current

    def set_current(self, curr): self.current = curr

    def get_left(self): return self.left

    def set_left(self, lef): self.left = lef

    def get_right(self): return self.right

    def set_right(self, rght): self.right = rght

class Huffman(Tree):

    def __init__(self):

        self.tree = None
        self.list_of_characters = None
        self.data = None
        self.info = ''
        
    def get_tree(self): return self.tree

    def set_tree(self, tree): self.tree = tree

    def get_list_of_characters(self): return self.list_of_characters

    def set_list_of_characters(self, clist): self.list_of_characters = clist

    def get_data(self): return self.data

    def set_data(self, data): self.data = data

    def get_info(self): return self.info

    def set_info(self, info): self.info = info


# builds a tree from the input text

    def building_tree(self, inpt):

        characters = '\'"AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz 1234567890!@#$%^&*()-_+={}[]\|<>,.?/~`\n'

        # arrays to hold the counted characters and the trees
        chars_count = []
        baseTrees = []

        # if the character in the list is in the input it counts it and ands to list
        for i in characters:

            if i in inpt:

                chars_count.append([i, inpt.count(i)])

        chars_count.sort(key=self.get_key)
        # print(chars_count)

        # makes a base tree for each counted letter
        for i in chars_count:

            baseTrees.append(Tree(None, None, i))

        tree1 = baseTrees

        # joins the trees together into a binary tree
        while len(tree1) > 1:
            if isinstance(tree1[0].get_current(), list) and isinstance(tree1[1].get_current(), list):

                newCurrent = tree1[0].get_current()[1] + tree1[1].get_current()[1]

                if tree1[0].get_current()[1] <= tree1[1].get_current()[1]:

                    newLeft = tree1[0]
                    newRight = tree1[1]

                else:

                    newLeft = tree1[1]
                    newRight = tree1[0]

                newTree = Tree(newLeft, newRight, newCurrent)
                tree1.append(newTree)
                tree1.remove(newTree.get_left())
                tree1.remove(newTree.get_right())

            elif isinstance(tree1[0].get_current(), int) and isinstance(tree1[1].get_current(), int):

                newCurrent = tree1[0].get_current() + tree1[1].get_current()

                if tree1[0].get_current() <= tree1[1].get_current():

                    newLeft = tree1[0]
                    newRight = tree1[1]

                else:

                    newLeft = tree1[1]
                    newRight = tree1[0]

                newTree = Tree(newLeft, newRight, newCurrent)
                tree1.append(newTree)
                tree1.remove(newTree.get_left())
                tree1.remove(newTree.get_right())

            elif isinstance(tree1[0].get_current(), int) and isinstance(tree1[1].get_current(), list):

                newCurrent = tree1[0].get_current() + tree1[1].get_current()[1]

                if tree1[0].get_current() <= tree1[1].get_current()[1]:

                    newLeft = tree1[0]
                    newRight = tree1[1]

                else:

                    newLeft = tree1[1]
                    newRight = tree1[0]

                newTree = Tree(newLeft, newRight, newCurrent)
                tree1.append(newTree)
                tree1.remove(newTree.get_left())
                tree1.remove(newTree.get_right())

            elif isinstance(tree1[0].get_current(), list) and isinstance(tree1[1].get_current(), int):

                newCurrent = tree1[0].get_current()[1] + tree1[1].get_current()

                if tree1[0].get_current()[1] <= tree1[1].get_current():

                    newLeft = tree1[0]
                    newRight = tree1[1]

                else:

                    newLeft = tree1[1]
                    newRight = tree1[0]

                newTree = Tree(newLeft, newRight, newCurrent)
                tree1.append(newTree)
                tree1.remove(newTree.get_left())
                tree1.remove(newTree.get_right())

            tree1.sort(key=self.get_key2)

        # print(str(chars_count))
        self.set_tree(tree1[0])
        self.set_list_of_characters(chars_count)
        self.set_data([tree1[0], chars_count])
        # print(tree1[0].get_current())
        return [tree1[0], chars_count]

    def get_key(self, x):

        return x[1]

    def get_key2(self, x):

        if isinstance(x.get_current(), int):

            return x.get_current()

        elif isinstance(x.get_current(), list):

            return x.get_current()[1]


    # go left add 0
    # go right add 1
    def traverse_tree(self, data, wentleft, wentright, val, letterlist):

        if len(letterlist) == len(data[1]):
            # print(letterlist)
            return letterlist

        if wentleft:

            val = val + '0'

        if wentright:

            val = val + '1'

        # print(val)

        if isinstance(data[0].get_current(), int):

            if isinstance(data[0].get_left().get_current(), list):

                for i in data[1]:

                    if i[0] == data[0].get_left().get_current()[0]:

                        if [i[0], str(val) + '0'] not in letterlist:

                            letterlist.append([i[0], str(val) + '0'])
                            # print([i[0], str(val) + '1'])

            if isinstance(data[0].get_right().get_current(), list):

                for i in data[1]:

                    if i[0] == data[0].get_right().get_current()[0]:

                        if [i[0], str(val) + '1'] not in letterlist:

                            letterlist.append([i[0], str(val) + '1'])
                            # print([i[0], str(val) + '0'])

            if isinstance(data[0].get_left().get_current(), list) and isinstance(data[0].get_right().get_current(), list):

                for i in data[1]:

                    if i[0] == data[0].get_left().get_current()[0]:

                        if [i[0], str(val) + '0'] not in letterlist:

                            letterlist.append([i[0], str(val) + '0'])
                            # print([i[0], str(val) + '1'])

                    if i[0] == data[0].get_right().get_current()[0]:

                        if [i[0], str(val) + '1'] not in letterlist:

                            letterlist.append([i[0], str(val) + '1'])
                            # print([i[0], str(val) + '0'])

            return self.traverse_tree([data[0].get_left(), data[1]], True, False, val, letterlist) or \
                self.traverse_tree([data[0].get_right(), data[1]], False, True, val, letterlist)

    def view_tree(self, data):

        if data[0].get_left() is not None and data[0].get_right() is not None:

            print("Current: " + str(data[0].get_current()) + " Left: " + str(data[0].get_left().get_current()) +
                  " Right: " + str(data[0].get_right().get_current()))

            self.view_tree([data[0].get_left()])
            self.view_tree([data[0].get_right()])

    def get_encoded_text(self, text, listofcharacters):

        encoded = ''

        for character in text:

            for j in listofcharacters:

                if character == j[0]:

                    encoded += j[1]

        return encoded

    def add_extra(self, encodedtext):

        extra = (8 - len(encodedtext)) % 8

        for i in range(extra):

            encodedtext += "0"

        info = "{0:08b}".format(extra)
        encodedtext = info + encodedtext

        self.set_info(info)
        # print(info)

        return encodedtext

    def get_byte_array(self, encodedtext):

        if len(encodedtext) % 8 != 0:

            print("encoded text has a partial byte")

        bt = bytearray()

        for i in range(0, len(encodedtext), 8):

            byte = encodedtext[i:i + 8]
            bt.append(int(byte, 2))

        # print(bt)
        return bt

    def encode(self, file_to_encode, outputfile):

        with open(file_to_encode, 'r+') as textfile, open(outputfile, 'wb') as outputfile:

            text = textfile.read()
            text = text.rstrip()

            #print(text)
            text = text.replace(" 0.101 ", "a")
            text = text.replace(" -", "m")
            text = text.replace(" 0 0 0 0 0 0 0 0 0 ", "z9")
            text = text.replace(" 0 0 0 0 0 0 0 0 ", "z8")
            text = text.replace(" 0 0 0 0 0 0 0 ", "z7")
            text = text.replace(" 0 0 0 0 0 0 ", "z6")
            text = text.replace(" 0 0 0 0 0 ", "z5")
            text = text.replace(" 0 0 0 0 ", "z4")
            text = text.replace(" 0 0 0 ", "z3")
            text = text.replace(" 0 0 ", "z2")
            text = text.replace(" 0 ", "z1")
            text = text.replace(" 0", "b")
            text = text.replace(" 1", "c")
            text = text.replace(" 2", "d")
            text = text.replace(" 3", "e")
            text = text.replace(" 4", "f")
            text = text.replace(" 5", "g")
            text = text.replace(" 6", "h")
            text = text.replace(" 7", "i")
            text = text.replace(" 8", "j")
            text = text.replace(" 9", "k")
            text = text.replace(".0", "l")
            text = text.replace(".1", "&")
            text = text.replace(".2", "n")
            text = text.replace(".3", "o")
            text = text.replace(".4", "p")
            text = text.replace(".5", "q")
            text = text.replace(".6", "r")
            text = text.replace(".7", "s")
            text = text.replace(".8", "t")
            text = text.replace(".9", "u")
            text = text.replace("-0", "v")
            text = text.replace("-1", "w")
            text = text.replace("-2", "x")
            text = text.replace("-3", "y")
            text = text.replace("-4", "!")
            text = text.replace("-5", "@")
            text = text.replace("-6", "#")
            text = text.replace("-7", "$")
            text = text.replace("-8", "%")
            text = text.replace("-9", "^")
            tree = self.building_tree(text)
            assignment = self.traverse_tree(tree, None, None, '', [])

            self.set_tree(tree)
            self.set_list_of_characters(assignment)

            # tree = self.get_tree()
            # assignment = self.get_list_of_characters()

            # encode the text with the bytes from the tree
            encoded = self.get_encoded_text(text, assignment)

            # if not divisible by 8 add extra 0s
            fully_encoded = self.add_extra(encoded)

            # this will get the byte arrays
            ba = self.get_byte_array(fully_encoded)

            # print(ba)
            outputfile.write(ba)

    def decompression(self, file_to_decode):

        with open(file_to_decode, 'rb') as inputfile:

            bit_text = ""

            encoded_byte = inputfile.read(1)
            # print(encoded_byte)

            while encoded_byte != b'':

                # encoded_byte = "{:08b}".format(ord(encoded_byte))
                encoded_byte = ord(encoded_byte)
                # print(encoded_byte)
                bits = bin(encoded_byte)[2:].rjust(8, '0')
                bit_text += bits
                encoded_byte = inputfile.read(1)

            # print("bit text: " + str(bit_text))

            full_data = bit_text[:8]
            # print("full data:" + str(full_data))

            extra_data = int(full_data, 2)
            # print("Extra data: " + str(extra_data))

            full_encoded_text = bit_text[8:]
            # print("full encoded text: " + str(full_encoded_text))

            encoded_text = full_encoded_text[:-1*extra_data]
            # print("Encoded Text: " + str(encoded_text))

            # NOW ENCODED TEXT IS A STRING OF 1's AND 0's
            # print("Encoded Text To Decode: " + str(encoded_text))
            return encoded_text

    def decoding(self, encoded_text, output_file):

        starting_tree = self.get_tree()[0]
        running_tree = self.get_tree()[0]

        with open(output_file, 'w') as outputfile:

            for i in encoded_text:

                # print("Current: " + str(running_tree.get_current()))

                if isinstance(running_tree.get_current(), int):

                    if int(i) == 1:

                        running_tree = running_tree.get_right()

                    if int(i) == 0:

                        running_tree = running_tree.get_left()

                if isinstance(running_tree.get_current(), list):

                    # print("Writing: " + str(running_tree.get_current()[0]))
                    outputfile.write(running_tree.get_current()[0])
                    running_tree = starting_tree

    def decode(self, encoded_file, output_file):

        to_decode = self.decompression(encoded_file)
        self.decoding(to_decode, output_file)
        text = ""
        with open(output_file, 'r') as outputfile:
            text = outputfile.read()
            text = text.replace("^", "-9")
            text = text.replace("%", "-8")
            text = text.replace("$", "-7")
            text = text.replace("#", "-6")
            text = text.replace("@", "-5")
            text = text.replace("!", "-4")
            text = text.replace("y", "-3")
            text = text.replace("x", "-2")
            text = text.replace("w", "-1")
            text = text.replace("v", "-0")
            text = text.replace("u", ".9")
            text = text.replace("t", ".8")
            text = text.replace("s", ".7")
            text = text.replace("r", ".6")
            text = text.replace("q", ".5")
            text = text.replace("p", ".4")
            text = text.replace("o", ".3")
            text = text.replace("n", ".2")
            text = text.replace("&", ".1")
            text = text.replace("l", ".0")
            text = text.replace("k", " 9")
            text = text.replace("j", " 8")
            text = text.replace("i", " 7")
            text = text.replace("h", " 6")
            text = text.replace("g", " 5")
            text = text.replace("f", " 4")
            text = text.replace("e", " 3")
            text = text.replace("d", " 2")
            text = text.replace("c", " 1")
            text = text.replace("b", " 0")
            text = text.replace("z1", " 0 ")
            text = text.replace("z2", " 0 0 ")
            text = text.replace("z3", " 0 0 0 ")
            text = text.replace("z4", " 0 0 0 0 ")
            text = text.replace("z5", " 0 0 0 0 0 ")
            text = text.replace("z6", " 0 0 0 0 0 0 ")
            text = text.replace("z7", " 0 0 0 0 0 0 0 ")
            text = text.replace("z8", " 0 0 0 0 0 0 0 0 ")
            text = text.replace("z9", " 0 0 0 0 0 0 0 0 0 ")
            text = text.replace("m", " -")
            text = text.replace("a", " 0.101 ")
        with open(output_file, 'w') as outputfile:
            outputfile.write(text)

h = Huffman()
h.encode('FILEPATH\\test.txt', 'FILEPATH\\encoded.bin')
h.decode('FILEPATH\\encoded.bin', 'FILEPATH\\decoded.txt')
h.view_tree(h.get_data())

print("\n")

h2 = Huffman()
h2.encode('FILEPATH\\testREM.txt', 'FILEPATH\\encodedREM.bin')
h2.decode('FILEPATH\\encodedREM.bin', 'FILEPATH\\decodedREM.txt')
h2.view_tree(h2.get_data())
