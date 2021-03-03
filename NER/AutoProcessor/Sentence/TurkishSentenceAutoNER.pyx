from Dictionary.Word cimport Word
from MorphologicalAnalysis.MorphologicalTag import MorphologicalTag
from AnnotatedSentence.AnnotatedSentence cimport AnnotatedSentence
from AnnotatedSentence.AnnotatedWord cimport AnnotatedWord
from NER.AutoProcessor.Sentence.SentenceAutoNER cimport SentenceAutoNER


cdef class TurkishSentenceAutoNER(SentenceAutoNER):

    cpdef autoDetectPerson(self, AnnotatedSentence sentence):
        """
        The method assigns the words "bay" and "bayan" PERSON tag. The method also checks the PERSON gazetteer, and if
        the word exists in the gazetteer, it assigns PERSON tag.

        PARAMETERS
        ----------
        sentence : AnnotatedSentence
            The sentence for which PERSON named entities checked.
        """
        cdef int i
        cdef AnnotatedWord word
        for i in range(sentence.wordCount()):
            word = sentence.getWord(i)
            if isinstance(word, AnnotatedWord) and word.getNamedEntityType() is None and word.getParse() is not None:
                if Word.isHonorific(word.getName()):
                    word.setNamedEntityType("PERSON")
                word.checkGazetteer(self.personGazetteer)

    cpdef autoDetectLocation(self, AnnotatedSentence sentence):
        """
        The method checks the LOCATION gazetteer, and if the word exists in the gazetteer, it assigns the LOCATION tag.

        PARAMETERS
        ----------
        sentence : AnnotatedSentence
            The sentence for which LOCATION named entities checked.
        """
        cdef int i
        cdef AnnotatedWord word
        for i in range(sentence.wordCount()):
            word = sentence.getWord(i)
            if isinstance(word, AnnotatedWord) and word.getNamedEntityType() is None and word.getParse() is not None:
                word.checkGazetteer(self.locationGazetteer)

    cpdef autoDetectOrganization(self, AnnotatedSentence sentence):
        """
        The method assigns the words "corp.", "inc.", and "co" ORGANIZATION tag. The method also checks the
        ORGANIZATION gazetteer, and if the word exists in the gazetteer, it assigns ORGANIZATION tag.

        PARAMETERS
        ----------
        sentence : AnnotatedSentence
            The sentence for which ORGANIZATION named entities checked.
        """
        cdef int i
        cdef AnnotatedWord word
        for i in range(sentence.wordCount()):
            word = sentence.getWord(i)
            if isinstance(word, AnnotatedWord) and word.getNamedEntityType() is None and word.getParse() is not None:
                if Word.isOrganization(word.getName()):
                    word.setNamedEntityType("ORGANIZATION")
                word.checkGazetteer(self.organizationGazetteer)

    cpdef autoDetectTime(self, AnnotatedSentence sentence):
        """
        The method checks for the TIME entities using regular expressions. After that, if the expression is a TIME
        expression, it also assigns the previous texts, which are numbers, TIME tag.

        PARAMETERS
        ----------
        sentence : AnnotatedSentence
            The sentence for which TIME named entities checked.
        """
        cdef int i
        cdef AnnotatedWord word, previous
        for i in range(sentence.wordCount()):
            word = sentence.getWord(i)
            if isinstance(word, AnnotatedWord) and word.getNamedEntityType() is None and word.getParse() is not None:
                if Word.isTime(word.getName().lower()):
                    word.setNamedEntityType("TIME")
                    if i > 0:
                        previous = sentence.getWord(i - 1)
                        if isinstance(previous, AnnotatedWord) and \
                                previous.getParse().containsTag(MorphologicalTag.CARDINAL):
                            previous.setNamedEntityType("TIME")

    cpdef autoDetectMoney(self, AnnotatedSentence sentence):
        """
        The method checks for the MONEY entities using regular expressions. After that, if the expression is a MONEY
        expression, it also assigns the previous text, which may included numbers or some monetarial texts, MONEY tag.

        PARAMETERS
        ----------
        sentence :AnnotatedSentence
            The sentence for which MONEY named entities checked.
        """
        cdef int i, j
        cdef AnnotatedWord word, previous
        for i in range(sentence.wordCount()):
            word = sentence.getWord(i)
            if isinstance(word, AnnotatedWord) and word.getNamedEntityType() is None and word.getParse() is not None:
                if Word.isMoney(word.getName().lower()):
                    word.setNamedEntityType("MONEY")
                    j = i - 1
                    while j >= 0:
                        previous = sentence.getWord(j)
                        if isinstance(previous, AnnotatedWord) and previous.getParse() is not None and \
                                (previous.getName() == "amerikan" or
                                 previous.getParse().containsTag(MorphologicalTag.REAL) or
                                 previous.getParse().containsTag(MorphologicalTag.CARDINAL) or
                                 previous.getParse().containsTag(MorphologicalTag.REAL)):
                            previous.setNamedEntityType("TIME")
                        else:
                            break
                        j = j - 1
