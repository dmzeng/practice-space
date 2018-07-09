def stringCount():

    file = open("string.txt", "r")
    
    string = input("What is your string?" )
    count = len(string.split())
    print("Your string is " + str(count) + " words long!")

stringCount()

def pigLatin():
    vowels = 'aeiou'
    string = input("Give me a string to translate to pig latin! ")
    wordlist = string.split()
    for index1, word in enumerate(wordlist):
        for index2, char in enumerate(word):
            if char in vowels:
                wordlist[index1] = word[index2:] + "-" + word[:index2] + 'ay'
    print(' '.join(wordlist))
        
pigLatin()

