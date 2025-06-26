from textual.app import ComposeResult
from textual.containers import HorizontalGroup
from textual.widgets import Switch


class TransmitterControlWidget(HorizontalGroup):
    def compose(self) -> ComposeResult:
        yield Switch(id="TransmitSwitch")
