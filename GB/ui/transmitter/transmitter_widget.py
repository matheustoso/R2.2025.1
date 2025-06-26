from textual import on
from textual.reactive import reactive
from textual.app import ComposeResult
from textual.containers import HorizontalGroup
from textual.widgets import Digits, Static, Switch, Log

from ui.transmitter.transmitter_state_widget import TransmitterStateWidget
from ui.transmitter.transmitter_control_widget import TransmitterControlWidget
from domain.channel.signals import Signals
from domain.transmitter.transmitter_state import TransmitterState


class TransmitterWidget(HorizontalGroup):
    time = reactive(0)

    def compose(self) -> ComposeResult:
        yield Digits(f"{self.number}", id="TransmitterLabel")
        yield TransmitterStateWidget()
        yield TransmitterControlWidget()
        yield Static(id="TransmitterNode")

    def on_mount(self) -> None:
        self.state_service = self.set_interval(1, self.update_state)
        self.transmitting = self.set_interval(1, self.transmit, pause=True)
        self.backoff_timer = self.set_interval(1, self.update_time, pause=True)

    def update_time(self):
        self.time += 1
        remaining = self.transmitter.backoff_time - self.time
        widget = self.query_one("#BackoffTimer")
        widget.clear()
        widget.insert(f"{int(remaining)}")
        if self.time >= self.transmitter.backoff_time:
            self.backoff_timer.pause()
            self.time = 0.0
            self.transmitter.leave_backoff()
            widget.clear()
            widget.insert("0")

    @on(Switch.Changed, "#TransmitSwitch")
    async def on_transmit(self, event: Switch.Changed):
        if event.value:
            self.transmitting.resume()
            event.switch.disabled = True

    def transmit(self):
        if self.transmitter.can_send:            
            self.transmitter.transmit()

        elif self.transmitter.listen_for_collisions:
            self.wait_time = 2 * len(self.transmitter.channel_access_node.channel.nodes)
            self.transmitter.listen()

        elif self.transmitter.listening:
            self.wait_time -= 1
            if self.wait_time <= 0:
                self.finish_transmission()
                self.transmitter.finish()

        else:
            self.transmitter.sense()
            
    def finish_transmission(self):
        if self.transmitter.state is TransmitterState.BACKOFF:
            return
                
        self.wait_time = 2 * len(self.transmitter.channel_access_node.channel.nodes)
        
        switch = self.query_one("#TransmitSwitch")
        self.transmitting.pause()
        switch.disabled = False
        switch.value = False
        

    def update_state(self):
        if self.transmitter is None:
            return

        if self.transmitter.collision:
            self.transmitter.handle_collision()
            
        if self.transmitter.backoff_time > 0:
            self.backoff_timer.resume()

        self.update_transmitter()
        self.update_node()
        self.transmitter.channel_access_node.fulfil_transmission()

    def update_transmitter(self):
        sensing_widget = self.query_one("#SensingRadio")
        transmitting_widget = self.query_one("#TransmittingRadio")
        backoff_widget = self.query_one("#BackoffRadio")

        match self.transmitter.state:
            case TransmitterState.SENSING:
                sensing_widget.add_class("on")
                sensing_widget.value = True
                transmitting_widget.remove_class("on")
                transmitting_widget.value = False
                backoff_widget.remove_class("on")
                backoff_widget.value = False

            case TransmitterState.TRANSMITTING:
                sensing_widget.remove_class("on")
                sensing_widget.value = False
                transmitting_widget.add_class("on")
                transmitting_widget.value = True
                backoff_widget.remove_class("on")
                backoff_widget.value = False

            case TransmitterState.BACKOFF:
                sensing_widget.remove_class("on")
                sensing_widget.value = False
                transmitting_widget.remove_class("on")
                transmitting_widget.value = False
                backoff_widget.add_class("on")
                backoff_widget.value = True

            case _:
                sensing_widget.remove_class("on")
                sensing_widget.value = False
                transmitting_widget.remove_class("on")
                transmitting_widget.value = False
                backoff_widget.remove_class("on")
                backoff_widget.value = False

    def update_node(self):
        node_widget = self.query_one("#TransmitterNode")

        match self.transmitter.channel_access_node.signal:
            case Signals.DATA:
                node_widget.add_class("data")
                node_widget.remove_class("collision")
                node_widget.remove_class("jam")

            case Signals.COLLISION:
                node_widget.remove_class("data")
                node_widget.add_class("collision")
                node_widget.remove_class("jam")

            case Signals.JAM:
                node_widget.remove_class("data")
                node_widget.remove_class("collision")
                node_widget.add_class("jam")

            case _:
                node_widget.remove_class("data")
                node_widget.remove_class("collision")
                node_widget.remove_class("jam")
