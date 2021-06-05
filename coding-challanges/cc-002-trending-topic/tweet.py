import re
from collections import Counter
from stop_words_english import stop_words
def topics(top=5):

    with open("tweets_Jerusalem_small.txt", mode="r") as f:
        file = f.readlines()

    newFile = [ j 
                for i in file 
                for j in re.findall(r"[\w']+|[#'.,!?;]", i)[2:] 
                if len(j)>3 and j not in stop_words and j.isalpha()]

    top_list = Counter(newFile).most_common(top)
    
    for (i,j) in top_list:
        print(i)
        
    print("\nFollowing line is extra from me :D ")
    return top_list
        
print(topics())

