from AnnotatedSentence.ViewLayerType import ViewLayerType
from NamedEntityRecognition.AutoNER cimport AutoNER
from AnnotatedTree.ParseNodeDrawable cimport ParseNodeDrawable
from AnnotatedTree.ParseTreeDrawable cimport ParseTreeDrawable
from AnnotatedTree.Processor.Condition.IsTransferable cimport IsTransferable
from AnnotatedTree.Processor.NodeDrawableCollector cimport NodeDrawableCollector


cdef class TreeAutoNER(AutoNER):

    cdef object second_language

    cpdef autoDetectPerson(self, ParseTreeDrawable parseTree):
        pass

    cpdef autoDetectLocation(self, ParseTreeDrawable parseTree):
        pass

    cpdef autoDetectOrganization(self, ParseTreeDrawable parseTree):
        pass

    cpdef autoDetectMoney(self, ParseTreeDrawable parseTree):
        pass

    cpdef autoDetectTime(self, ParseTreeDrawable parseTree):
        pass

    def __init__(self, secondLanguage: ViewLayerType):
        self.second_language = secondLanguage

    cpdef autoNER(self, ParseTreeDrawable parseTree):
        cdef NodeDrawableCollector node_drawable_collector
        cdef list leaf_list
        cdef ParseNodeDrawable parse_node
        self.autoDetectPerson(parseTree)
        self.autoDetectLocation(parseTree)
        self.autoDetectOrganization(parseTree)
        self.autoDetectMoney(parseTree)
        self.autoDetectTime(parseTree)
        node_drawable_collector = NodeDrawableCollector(parseTree.getRoot(), IsTransferable(self.second_language))
        leaf_list = node_drawable_collector.collect()
        for parse_node in leaf_list:
            if isinstance(parse_node, ParseNodeDrawable) and not parse_node.layerExists(ViewLayerType.NER):
                parse_node.getLayerInfo().setLayerData(ViewLayerType.NER, "NONE")
        parseTree.saveWithFileName()
