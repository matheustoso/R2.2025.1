from random import randint

from domain.transmitter.transmitter_state import TransmitterState
from domain.channel.signals import Signals


class Transmitter:
    def __init__(self):
        self.channel_access_node = None
        self.state = None
        self.collision = False
        self.jammed = False
        self.can_send = False
        self.listen_for_collisions = False
        self.listening = False
        self.consecutive_backoffs = 0
        self.backoff_time = 0

    def receive(self, signal):
        if self.state is TransmitterState.TRANSMITTING and (
            signal is Signals.COLLISION or signal is Signals.JAM
        ):
            self.state = TransmitterState.BACKOFF
            self.collision = True
            self.jammed = signal is Signals.JAM

        elif signal is Signals.COLLISION:
            self.collision = True

    def handle_collision(self):
        if not self.collision:
            return

        if self.state is TransmitterState.BACKOFF:
            self.backoff()

        if not self.jammed:
            self.channel_access_node.transmit(Signals.JAM, up=True, down=True)

        self.jammed = False
        self.collision = False

    def sense(self):
        self.state = TransmitterState.SENSING
        self.can_send = not self.channel_access_node.busy

    def transmit(self):
        if self.can_send:
            self.state = TransmitterState.TRANSMITTING
            self.channel_access_node.transmit(Signals.DATA, up=True, down=True)
            self.can_send = False
            self.listen_for_collisions = True

    def listen(self):
        self.listen_for_collisions = False
        self.listening = True

    def finish(self):
        if self.state is TransmitterState.BACKOFF:
            return

        self.consecutive_backoffs = 0
        self.state = None
        self.listening = False

    def backoff(self):
        self.consecutive_backoffs += 1
        k = (2**self.consecutive_backoffs) - 1
        self.backoff_time = randint(0, k) * len(self.channel_access_node.channel.nodes)
        if self.backoff_time == 0:
            self.leave_backoff()

    def leave_backoff(self):
        self.backoff_time = 0
        self.state = None
        self.listening = False
