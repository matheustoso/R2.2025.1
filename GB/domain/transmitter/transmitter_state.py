from enum import Enum


class TransmitterState(Enum):
    SENSING = 1
    TRANSMITTING = 2
    BACKOFF = 3
