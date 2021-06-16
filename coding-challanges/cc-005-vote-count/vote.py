

def majority_vote(liste=["A", "A", "A", "B", "C", "A", "C", "C", "C", "C"]):
    return(max(liste, key=liste.count))
    


from collections import Counter
def most_wanted(liste=["A", "A", "A", "B", "C", "A", "C", "C", "C", "C"]):
    return Counter(liste).most_common(2)[1][0]

print(majority_vote())
print(most_wanted())