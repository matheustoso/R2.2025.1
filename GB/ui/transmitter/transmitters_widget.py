from textual import on
from textual.app import ComposeResult
from textual.containers import (
    VerticalScroll,
    VerticalGroup,
)
from textual.widgets import Button

from ui.transmitter.transmitter_list_control_widget import TransmittersListControlWidget
from ui.transmitter.transmitter_widget import TransmitterWidget
from domain.transmitter.transmitter import Transmitter
from domain.channel.channel import Channel


class TransmittersWidget(VerticalGroup):

    def compose(self) -> ComposeResult:
        yield VerticalScroll(id="TransmittersList")
        yield TransmittersListControlWidget()

    def on_mount(self) -> None:
        self.transmitters = []
        self.channel = Channel()

    @on(Button.Pressed, "#AddTransmitterButton")
    def on_add_transmitter_press(self) -> None:
        new_transmitter = Transmitter()
        self.channel.add_transmitter(new_transmitter)

        new_transmitter_widget = TransmitterWidget()
        new_transmitter_widget.transmitter = new_transmitter
        new_transmitter_widget.number = new_transmitter.channel_access_node.position + 1
        self.query_one("#TransmittersList").mount(new_transmitter_widget)
        new_transmitter_widget.scroll_visible()
