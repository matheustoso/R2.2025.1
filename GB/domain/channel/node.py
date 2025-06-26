from domain.channel.node_type import NodeType
from domain.channel.signals import Signals


class Node:
    def __init__(self, transmitter, position, type, channel):
        self.transmitter = transmitter
        self.position = position
        self.type = type
        self.channel = channel
        self.busy = False
        self.signal = None

    def transmit(self, signal, up=False, down=False):
        if self.busy:
            signal = Signals.COLLISION

        self.signal = signal
        self.busy = True
        self.up = up
        self.down = down
        
        
    def fulfil_transmission(self):  
        if not self.busy:
            return
        
        if self.signal is not Signals.COLLISION:

            if self.down and self.type is not NodeType.FIRST:
                self.channel.transmit_down(self.signal, self.position)

            if self.up and self.type is not NodeType.LAST:
                self.channel.transmit_up(self.signal, self.position)
                
        self.transmitter.receive(self.signal)
        
        self.signal = None
        self.busy = False
        self.up = False
        self.down = False
