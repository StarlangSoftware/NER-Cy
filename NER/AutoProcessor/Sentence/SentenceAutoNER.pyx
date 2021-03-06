from AnnotatedSentence.AnnotatedWord cimport AnnotatedWord


cdef class SentenceAutoNER(AutoNER):

    cpdef autoDetectPerson(self, AnnotatedSentence sentence):
        """
        The method should detect PERSON named entities. PERSON corresponds to people or
        characters. Example: {\bf Atatürk} yurdu düşmanlardan kurtardı.

        PARAMETERS
        ----------
        sentence : AnnotatedSentence
            The sentence for which PERSON named entities checked.
        """
        pass

    cpdef autoDetectLocation(self, AnnotatedSentence sentence):
        """
        The method should detect LOCATION named entities. LOCATION corresponds to regions,
        mountains, seas. Example: Ülkemizin başkenti Ankara'dır.

        PARAMETERS
        ----------
        sentence : AnnotatedSentence
            The sentence for which LOCATION named entities checked.
        """
        pass

    cpdef autoDetectOrganization(self, AnnotatedSentence sentence):
        """
        The method should detect ORGANIZATION named entities. ORGANIZATION corresponds to companies,
        teams etc. Example:  IMKB günü 60 puan yükselerek kapattı.

        PARAMETERS
        ----------
        sentence : AnnotatedSentence
            The sentence for which ORGANIZATION named entities checked.
        """
        pass

    cpdef autoDetectMoney(self, AnnotatedSentence sentence):
        """
        The method should detect MONEY named entities. MONEY corresponds to monetarial
        expressions. Example: Geçen gün 3000 TL kazandık.

        PARAMETERS
        ----------
        sentence : AnnotatedSentence
            The sentence for which MONEY named entities checked.
        """
        pass

    cpdef autoDetectTime(self, AnnotatedSentence sentence):
        """
        The method should detect TIME named entities. TIME corresponds to time
        expressions. Example: Cuma günü tatil yapacağım.

        PARAMETERS
        ----------
        sentence : AnnotatedSentence
            The sentence for which TIME named entities checked.
        """
        pass

    cpdef autoNER(self, AnnotatedSentence sentence):
        """
        The main method to automatically detect named entities in a sentence. The algorithm
        1. Detects PERSON(s).
        2. Detects LOCATION(s).
        3. Detects ORGANIZATION(s).
        4. Detects MONEY.
        5. Detects TIME.
        For not detected words, the algorithm sets the named entity "NONE".

        PARAMETERS
        ----------
        sentence : AnnotatedSentence
            The sentence for which named entities checked.
        """
        cdef int i
        cdef AnnotatedWord word
        self.autoDetectPerson(sentence)
        self.autoDetectLocation(sentence)
        self.autoDetectOrganization(sentence)
        self.autoDetectMoney(sentence)
        self.autoDetectTime(sentence)
        for i in range(sentence.wordCount()):
            word = sentence.getWord(i)
            if isinstance(word, AnnotatedWord):
                if word.getNamedEntityType() is None:
                    word.setNamedEntityType("NONE")
