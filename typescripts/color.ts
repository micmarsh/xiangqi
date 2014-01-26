///<reference path="actor.ts"/>

class Color extends Actor {

    onReceive(message: Message, sender: Actor) {
        switch(message.type) {
            case "get-color":
                // id.send({type:"get-color"}, this);
                // storage.send({type:"get-color"}, this);
                this.send({type:"color", message:"red"}, this);
                break;
            case "color":
                this.parent.send(message, this);
        }
    }
}

class King extends Actor {
    color: Actor
    constructor(p) {
        super(p);
        this.color = new Color(this);
    }
    onReceive(m: Message, s:Actor) {
        switch(m.type) {
            case "get-color":
                this.color.send(m,this);
                break;
            case "color":
                console.log(m);
        }
    }
}

var king = new King(null);
king.send({type:"get-color"},null);


