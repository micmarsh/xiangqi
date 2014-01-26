interface Message {
    type: string;
    data?: any;
}

class Actor {

    parent:Actor

    constructor(parent: Actor) {
        this.parent = parent;
    }

    send(message: Message, sender: Actor) {
        this.onReceive(message, sender);
    }

    onReceive(message: Message, sender: Actor) {
        throw new Error("This method is abstract");
    }
}


