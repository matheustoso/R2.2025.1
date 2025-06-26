STYLESHEET = """
TransmittersWidget {
    height: 100%;
    width: 100%;
    margin: 1;
    background: $surface;
}

#TransmittersListWidget {
    width: 100%;
}

TransmittersListControlWidget {
    border_top: solid $background;
    width: 100%;
}

TransmitterControlWidget {
    padding: 1;
    width: 12;
}

TransmitterStateWidget {
    padding: 1;
    background: $background;
    content-align: center middle;
    align: center middle;
}

TransmitterWidget {
    height: 5;
    width: 100%;
    min-width: 130;
    margin: 1;
    padding: 0;
    background: $panel;
}

#TransmitterNode {
    height: 3;
    outline: tall $surface;
    width: 16;
    background: black;
    margin: 1;
    padding: 0;
}

#TransmitterNode.data {
    background: $success;
}

#TransmitterNode.collision {
    background: $error;
}

#TransmitterNode.jam {
    background: $warning;
}

#TransmitSwitch {
    height: 3;
    color: $success;
}

#SensingRadio {
    background: black;
    padding: 0 2 0 1;
}

#SensingRadio.on {
    background: $primary;
}

#TransmittingRadio {
    background: black;
    padding: 0 2 0 1;
}

#TransmittingRadio.on {
    background: $success;
}

#BackoffRadio {
    background: black;
    padding: 0 2 0 1;
}

#BackoffRadio.on {
    background: $error;
}

#BackoffTimer {
    height: 3;
    outline: tall $surface;
    width: 32;
    background: black;
    text-align: center;
}

#AddTransmitterButton {
    width: 100%;
}

#TransmitterLabel {
    height: 100%;
    width: auto;
    color: $foreground-muted;
    border: thick $border;
    margin: 0;
    padding: 0 1;
    text-align: center;
    text-style: bold;
}
"""