from textual.app import ComposeResult
from textual.containers import HorizontalGroup
from textual.widgets import Button


class TransmittersListControlWidget(HorizontalGroup):
    def compose(self) -> ComposeResult:
        yield Button(id="AddTransmitterButton", label="+", variant="success")
