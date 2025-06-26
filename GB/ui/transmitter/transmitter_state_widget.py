from textual.app import ComposeResult
from textual.containers import HorizontalGroup
from textual.widgets import RadioButton, TextArea


class TransmitterStateWidget(HorizontalGroup):
    def compose(self) -> ComposeResult:
        yield RadioButton(id="SensingRadio", label="Sensing")
        yield RadioButton(id="TransmittingRadio", label="Transmitting")
        yield RadioButton(id="BackoffRadio", label="Backoff")
        yield TextArea(text="0", id="BackoffTimer")
