from textual.app import App, ComposeResult
from textual.widgets import (
    Header,
    Footer,
)

from ui.transmitter.transmitters_widget import TransmittersWidget
from ui.style.style import *


class CsmaCdApp(App):
    CSS = STYLESHEET
    BINDINGS = [
        ("q", "quit", "Quit"),
    ]

    def compose(self) -> ComposeResult:
        self.theme = "gruvbox"
        yield Header(id="Header")
        yield TransmittersWidget()
        yield Footer(id="Footer")
