from domain.channel.node_type import NodeType
from domain.channel.node import Node

class Channel:
    def __init__(self):
        self.nodes = []
        
    def add_transmitter(self, transmitter):
        node_position = len(self.nodes)
        node_type = NodeType.FIRST if node_position == 0 else NodeType.LAST
        
        if node_type is NodeType.LAST and node_position > 1:
            self.nodes[-1].type = NodeType.MIDDLE
        
        new_node = Node(transmitter, node_position, node_type, self)
        self.nodes.append(new_node)
        transmitter.channel_access_node = new_node
        
    def transmit_down(self, signal, node_position):
        if node_position > 0:
            self.nodes[node_position - 1].transmit(signal, down=True)
        
    def transmit_up(self, signal, node_position):
        if node_position < len(self.nodes):
            self.nodes[node_position + 1].transmit(signal, up=True)