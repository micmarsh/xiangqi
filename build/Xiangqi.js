Elm.Xiangqi = Elm.Xiangqi || {};
Elm.Xiangqi.make = function (_elm) {
   _elm.Xiangqi = _elm.Xiangqi || {};
   if (_elm.Xiangqi.values)
   return _elm.Xiangqi.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _E = _N.Error.make(_elm),
   _J = _N.JavaScript.make(_elm),
   $moduleName = "Xiangqi";
   var Basics = Elm.Basics.make(_elm);
   var Board = Elm.Board.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Constants = Elm.Constants.make(_elm);
   var GameState = Elm.GameState.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Parser = Elm.Parser.make(_elm);
   var Prelude = Elm.Prelude.make(_elm);
   var Sidebar = Elm.Sidebar.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var Window = Elm.Window.make(_elm);
   var _op = {};
   var rlift = F2(function (functions,
   c) {
      return A2(Signal._op["~"],
      functions,
      Signal.constant(c));
   });
   var centeredContainer = A3(Signal.lift2,
   Graphics.Element.container,
   Window.width,
   Window.height);
   var inMiddle = A2(rlift,
   centeredContainer,
   Graphics.Element.middle);
   var pieces2List = List.map(Parser.piece2List);
   var check = Native.Ports.portIn("check",
   Native.Ports.incomingSignal(function (v) {
      return typeof v === "object" && "check" in v && "mate" in v && "checker" in v ? {_: {}
                                                                                      ,check: typeof v.check === "boolean" ? _J.toBool(v.check) : _E.raise("invalid input, expecting JSBoolean but got " + v.check)
                                                                                      ,mate: typeof v.mate === "boolean" ? _J.toBool(v.mate) : _E.raise("invalid input, expecting JSBoolean but got " + v.mate)
                                                                                      ,checker: typeof v.checker === "string" || typeof v.checker === "object" && v.checker instanceof String ? _J.toString(v.checker) : _E.raise("invalid input, expecting JSString but got " + v.checker)} : _E.raise("invalid input, expecting JSObject [\"check\",\"mate\",\"checker\"] but got " + v);
   }));
   var connected = Native.Ports.portIn("connected",
   Native.Ports.incomingSignal(function (v) {
      return typeof v === "boolean" ? _J.toBool(v) : _E.raise("invalid input, expecting JSBoolean but got " + v);
   }));
   var inMoves = Native.Ports.portIn("inMoves",
   Native.Ports.incomingSignal(function (v) {
      return typeof v === "object" && "legal" in v && "move" in v ? {_: {}
                                                                    ,legal: typeof v.legal === "boolean" ? _J.toBool(v.legal) : _E.raise("invalid input, expecting JSBoolean but got " + v.legal)
                                                                    ,move: typeof v.move === "object" && "from" in v.move && "to" in v.move ? {_: {}
                                                                                                                                              ,from: typeof v.move.from === "string" || typeof v.move.from === "object" && v.move.from instanceof String ? _J.toString(v.move.from) : _E.raise("invalid input, expecting JSString but got " + v.move.from)
                                                                                                                                              ,to: typeof v.move.to === "string" || typeof v.move.to === "object" && v.move.to instanceof String ? _J.toString(v.move.to) : _E.raise("invalid input, expecting JSString but got " + v.move.to)} : _E.raise("invalid input, expecting JSObject [\"from\",\"to\"] but got " + v.move)} : _E.raise("invalid input, expecting JSObject [\"legal\",\"move\"] but got " + v);
   }));
   var color = Native.Ports.portIn("color",
   Native.Ports.incomingSignal(function (v) {
      return typeof v === "string" || typeof v === "object" && v instanceof String ? _J.toString(v) : _E.raise("invalid input, expecting JSString but got " + v);
   }));
   var stateInputs = {_: {}
                     ,checkStatus: check
                     ,color: color
                     ,moves: inMoves};
   var outMoves = Native.Ports.portOut("outMoves",
   Native.Ports.outgoingSignal(function (v) {
      return {from: _J.fromString(v.from)
             ,to: _J.fromString(v.to)};
   }),
   GameState.makeMoves(stateInputs));
   var gameState = GameState.makeGame(stateInputs);
   var pieces = A2(Signal.lift,
   function ($) {
      return pieces2List(function (_) {
         return _.pieces;
      }($));
   },
   gameState);
   var turn = A2(Signal.lift,
   function ($) {
      return Parser.encodeColor(function (_) {
         return _.turn;
      }($));
   },
   gameState);
   var state = Native.Ports.portOut("state",
   Native.Ports.outgoingSignal(function (v) {
      return {pieces: _J.fromList(v.pieces).map(function (v) {
                return _J.fromList(v).map(function (v) {
                   return _J.fromString(v);
                });
             })
             ,turn: _J.fromString(v.turn)};
   }),
   A3(Signal.lift2,
   F2(function (p,t) {
      return {_: {}
             ,pieces: p
             ,turn: t};
   }),
   pieces,
   turn));
   var uiInputs = {_: {}
                  ,color: color
                  ,connected: connected
                  ,gameState: gameState};
   var boardCanvas = Board.makeBoard(uiInputs);
   var sidebar = Sidebar.makeSideBar(uiInputs);
   var toDisplay = A3(Signal.lift2,
   F2(function (board,sidebar) {
      return A2(Graphics.Element.flow,
      Graphics.Element.right,
      _J.toList([board,sidebar]));
   }),
   boardCanvas,
   sidebar);
   var main = A2(Signal._op["~"],
   inMiddle,
   toDisplay);
   _elm.Xiangqi.values = {_op: _op
                         ,stateInputs: stateInputs
                         ,gameState: gameState
                         ,pieces2List: pieces2List
                         ,pieces: pieces
                         ,turn: turn
                         ,centeredContainer: centeredContainer
                         ,rlift: rlift
                         ,uiInputs: uiInputs
                         ,boardCanvas: boardCanvas
                         ,sidebar: sidebar
                         ,toDisplay: toDisplay
                         ,inMiddle: inMiddle
                         ,main: main};
   return _elm.Xiangqi.values;
};Elm.Sidebar = Elm.Sidebar || {};
Elm.Sidebar.make = function (_elm) {
   _elm.Sidebar = _elm.Sidebar || {};
   if (_elm.Sidebar.values)
   return _elm.Sidebar.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _E = _N.Error.make(_elm),
   _J = _N.JavaScript.make(_elm),
   $moduleName = "Sidebar";
   var Basics = Elm.Basics.make(_elm);
   var Board = Elm.Board.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Constants = Elm.Constants.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Model = Elm.Model.make(_elm);
   var Monad = Elm.Monad.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Prelude = Elm.Prelude.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var Disconnected = {ctor: "Disconnected"};
   var Connected = {ctor: "Connected"};
   var Waiting = {ctor: "Waiting"};
   var updateStatus = F2(function ($new,
   prev) {
      return $new ? Connected : _U.eq(prev,
      Waiting) ? Waiting : _U.eq(prev,
      Connected) ? Disconnected : Disconnected;
   });
   var whoseTurn = F2(function (player,
   turn) {
      return _U.eq(turn,
      player) ? "Your" : function () {
         switch (turn.ctor)
         {case "Black":
            return "Black\'s";
            case "Red": return "Red\'s";}
         _E.Case($moduleName,
         "between lines 20 and 22");
      }();
   });
   var spacerw = Graphics.Element.spacer(Constants.sideBarWidth);
   var squareSpacer = spacerw(Constants.sideBarWidth);
   var rectSpacer = spacerw(Constants.squareSize);
   var makePieceView = function (option) {
      return function () {
         switch (option.ctor)
         {case "Just":
            switch (option._0.ctor)
              {case "Piece":
                 return function () {
                      var sideLength = (Constants.sideBarWidth / 3 | 0) * 2;
                      var image = A2(Board.pieceImage,
                      option._0._0,
                      option._0._2);
                      var biggerImage = A3(Graphics.Element.size,
                      sideLength,
                      sideLength,
                      image);
                      return A2(Graphics.Element.flow,
                      Graphics.Element.down,
                      _J.toList([rectSpacer
                                ,biggerImage]));
                   }();}
              break;
            case "Nothing":
            return squareSpacer;}
         _E.Case($moduleName,
         "between lines 42 and 51");
      }();
   };
   var putTogether = F3(function (turn,
   piece,
   check) {
      return A2(Graphics.Element.flow,
      Graphics.Element.down,
      _J.toList([rectSpacer
                ,turn
                ,check
                ,piece]));
   });
   var shortSpacer = spacerw(Constants.squareSize / 3 | 0);
   var darkGrey = A3(Color.rgb,
   55,
   55,
   55);
   var color = Text.color;
   var applyColor = function (string) {
      return function () {
         var text = Text.toText(string);
         return function () {
            switch (string)
            {case "Black\'s":
               return A2(color,
                 Color.black,
                 text);
               case "Red\'s": return A2(color,
                 Color.red,
                 text);}
            return A2(color,darkGrey,text);
         }();
      }();
   };
   var waiting = function ($) {
      return Text.text(applyColor($));
   }("Waiting for other player...");
   var checkText = F2(function (player,
   check) {
      return function () {
         var makeText = function ($) {
            return Text.text(applyColor($));
         };
         return function () {
            switch (check.ctor)
            {case "Just":
               switch (check._0.ctor)
                 {case "Check":
                    return _U.eq(check._0._0,
                      player) ? makeText("You\'re in check!") : shortSpacer;}
                 break;}
            return shortSpacer;
         }();
      }();
   });
   var turnMessage = function (name) {
      return function () {
         var ending = color(darkGrey)(Text.toText(" Turn"));
         var phrase = _J.toList([name
                                ,ending]);
         var asElts = A2(List.map,
         Text.text,
         phrase);
         return A2(Graphics.Element.flow,
         Graphics.Element.right,
         asElts);
      }();
   };
   var makeTurnView = F2(function (gameState,
   color) {
      return function () {
         var playerColor = A2(Signal.lift,
         Model.playerADT,
         color);
         var turnText = Signal.lift(applyColor)(A3(Signal.lift2,
         whoseTurn,
         playerColor,
         A2(Signal.lift,
         function (_) {
            return _.turn;
         },
         gameState)));
         return A2(Signal.lift,
         turnMessage,
         turnText);
      }();
   });
   var disconnected = function ($) {
      return Text.text(color(Color.red)(Text.toText($)));
   }("Disconnected");
   var makeTitle = F2(function (turnView,
   connected) {
      return function () {
         switch (connected.ctor)
         {case "Connected":
            return turnView;
            case "Disconnected":
            return disconnected;
            case "Waiting": return waiting;}
         _E.Case($moduleName,
         "between lines 75 and 78");
      }();
   });
   var makeSideBar = function (_v11) {
      return function () {
         return function () {
            var checkMessage = A3(Signal.lift2,
            checkText,
            A2(Signal.lift,
            Model.playerADT,
            _v11.color),
            A2(Signal.lift,
            function (_) {
               return _.check;
            },
            _v11.gameState));
            var selectedPiece = A2(Signal.lift,
            function (_) {
               return _.selected;
            },
            _v11.gameState);
            var pieceViews = A2(Signal.lift,
            makePieceView,
            selectedPiece);
            var connStatus = A3(Signal.foldp,
            updateStatus,
            Waiting,
            _v11.connected);
            var turnViews = A2(makeTurnView,
            _v11.gameState,
            _v11.color);
            var titleViews = A3(Signal.lift2,
            makeTitle,
            turnViews,
            connStatus);
            var unsizedSidebar = A4(Signal.lift3,
            putTogether,
            titleViews,
            pieceViews,
            checkMessage);
            return A2(Signal.lift,
            Graphics.Element.width(Constants.sideBarWidth),
            unsizedSidebar);
         }();
      }();
   };
   _elm.Sidebar.values = {_op: _op
                         ,color: color
                         ,darkGrey: darkGrey
                         ,spacerw: spacerw
                         ,squareSpacer: squareSpacer
                         ,rectSpacer: rectSpacer
                         ,shortSpacer: shortSpacer
                         ,whoseTurn: whoseTurn
                         ,applyColor: applyColor
                         ,turnMessage: turnMessage
                         ,makePieceView: makePieceView
                         ,putTogether: putTogether
                         ,makeTurnView: makeTurnView
                         ,waiting: waiting
                         ,disconnected: disconnected
                         ,makeTitle: makeTitle
                         ,updateStatus: updateStatus
                         ,checkText: checkText
                         ,makeSideBar: makeSideBar
                         ,Waiting: Waiting
                         ,Connected: Connected
                         ,Disconnected: Disconnected};
   return _elm.Sidebar.values;
};Elm.Board = Elm.Board || {};
Elm.Board.make = function (_elm) {
   _elm.Board = _elm.Board || {};
   if (_elm.Board.values)
   return _elm.Board.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _E = _N.Error.make(_elm),
   _J = _N.JavaScript.make(_elm),
   $moduleName = "Board";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Constants = Elm.Constants.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var Input = Elm.Input.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Model = Elm.Model.make(_elm);
   var Mouse = Elm.Mouse.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Prelude = Elm.Prelude.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var Window = Elm.Window.make(_elm);
   var _op = {};
   var edgeOffset = 60;
   var collageBounds = A2(Graphics.Collage.collage,
   Constants.boardWidth + edgeOffset,
   Constants.boardHeight + edgeOffset);
   var rmap = F2(function (functions,
   c) {
      return A2(List.map,
      function (f) {
         return f(c);
      },
      functions);
   });
   var pieceRadius = Basics.toFloat(Constants.squareSize) / 2 - 5;
   var pieceName = function (kind) {
      return function () {
         switch (kind.ctor)
         {case "Advisor":
            return "advisor";
            case "Cannon": return "cannon";
            case "Chariot":
            return "chariot";
            case "Elephant":
            return "elephant";
            case "Horse": return "horse";
            case "King": return "king";
            case "Soldier":
            return "soldier";}
         _E.Case($moduleName,
         "between lines 27 and 34");
      }();
   };
   var pieceImage = F2(function (kind,
   color) {
      return function () {
         var cfolder = function () {
            switch (color.ctor)
            {case "Black": return "/black";
               case "Red": return "/red";}
            _E.Case($moduleName,
            "between lines 37 and 40");
         }();
         var fullFolder = _L.append(Constants.folder,
         cfolder);
         var fullPath = _L.append(fullFolder,
         _L.append("/",
         _L.append(pieceName(kind),
         ".png")));
         return A3(Graphics.Element.image,
         Constants.squareSize,
         Constants.squareSize,
         fullPath);
      }();
   });
   var initialMove = function (_v2) {
      return function () {
         switch (_v2.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: _v2._0 - Constants.centerWidth
                   ,_1: _v2._1 - Constants.centerHeight};}
         _E.Case($moduleName,
         "on line 25, column 28 to 65");
      }();
   };
   var translate2Pixels = F2(function (_v6,
   player) {
      return function () {
         switch (_v6.ctor)
         {case "_Tuple2":
            return function () {
                 var horIndex = Constants.char2Num(_v6._0);
                 var defaultWidth = horIndex * Constants.squareSize;
                 var vertIndex = _v6._1 - 1;
                 var defaultHeight = vertIndex * Constants.squareSize;
                 return function () {
                    switch (player.ctor)
                    {case "Black":
                       return {ctor: "_Tuple2"
                              ,_0: Constants.boardWidth - defaultWidth
                              ,_1: Constants.boardHeight - defaultHeight};
                       case "Red":
                       return {ctor: "_Tuple2"
                              ,_0: defaultWidth
                              ,_1: defaultHeight};}
                    _E.Case($moduleName,
                    "between lines 21 and 23");
                 }();
              }();}
         _E.Case($moduleName,
         "between lines 17 and 23");
      }();
   });
   var tmap = F2(function (fn,
   _v11) {
      return function () {
         switch (_v11.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: fn(_v11._0)
                   ,_1: fn(_v11._1)};}
         _E.Case($moduleName,
         "on line 12, column 6 to 20");
      }();
   });
   var toFloats = tmap(Basics.toFloat);
   var makePiece = F2(function (_v15,
   you) {
      return function () {
         switch (_v15.ctor)
         {case "Piece":
            return function () {
                 var numPosition = A2(translate2Pixels,
                 _v15._1,
                 you);
                 var moveTo = function ($) {
                    return toFloats(initialMove($));
                 }(numPosition);
                 return Graphics.Collage.move(moveTo)(Graphics.Collage.toForm(A2(pieceImage,
                 _v15._0,
                 _v15._2)));
              }();}
         _E.Case($moduleName,
         "between lines 49 and 53");
      }();
   });
   var imageWithPieces = F2(function (pieces,
   turn) {
      return function () {
         var pieceFns = A2(List.map,
         makePiece,
         pieces);
         var finalPieces = A2(rmap,
         pieceFns,
         turn);
         return {ctor: "::"
                ,_0: Graphics.Collage.toForm(Constants.boardImage)
                ,_1: finalPieces};
      }();
   });
   var makeBoard = function (_v20) {
      return function () {
         return function () {
            var player = A2(Signal.lift,
            Model.playerADT,
            _v20.color);
            var pieces = A2(Signal.lift,
            function (_) {
               return _.pieces;
            },
            _v20.gameState);
            var realDisplay = A2(Signal.lift2,
            imageWithPieces,
            pieces)(player);
            return A2(Signal.lift,
            collageBounds,
            realDisplay);
         }();
      }();
   };
   _elm.Board.values = {_op: _op
                       ,tmap: tmap
                       ,toFloats: toFloats
                       ,translate2Pixels: translate2Pixels
                       ,initialMove: initialMove
                       ,pieceName: pieceName
                       ,pieceImage: pieceImage
                       ,pieceRadius: pieceRadius
                       ,makePiece: makePiece
                       ,rmap: rmap
                       ,imageWithPieces: imageWithPieces
                       ,edgeOffset: edgeOffset
                       ,collageBounds: collageBounds
                       ,makeBoard: makeBoard};
   return _elm.Board.values;
};Elm.GameState = Elm.GameState || {};
Elm.GameState.make = function (_elm) {
   _elm.GameState = _elm.GameState || {};
   if (_elm.GameState.values)
   return _elm.GameState.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _E = _N.Error.make(_elm),
   _J = _N.JavaScript.make(_elm),
   $moduleName = "GameState";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var Http = Elm.Http.make(_elm);
   var Input = Elm.Input.make(_elm);
   var JavaScript = Elm.JavaScript.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Model = Elm.Model.make(_elm);
   var Monad = Elm.Monad.make(_elm);
   var Mouse = Elm.Mouse.make(_elm);
   var Moving = Elm.Moving.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Parser = Elm.Parser.make(_elm);
   var Prelude = Elm.Prelude.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var calculateCheck = F2(function (state,
   _v0) {
      return function () {
         return function () {
            var color = Model.playerADT(_v0.checker);
            return _v0.mate ? Maybe.Just(Model.CheckMate(color)) : _v0.check ? Maybe.Just(Model.Check(color)) : Maybe.Nothing;
         }();
      }();
   });
   var addCheckToState = F2(function (state,
   check) {
      return _U.replace([["check"
                         ,A2(calculateCheck,
                         state,
                         check)]],
      state);
   });
   var toggleTurn = function (turn) {
      return function () {
         switch (turn.ctor)
         {case "Black": return Model.Red;
            case "Red": return Model.Black;}
         _E.Case($moduleName,
         "between lines 64 and 66");
      }();
   };
   var convertMoveRecord = function (confirm) {
      return _U.replace([["move"
                         ,Parser.decodeMove(confirm.move)]],
      confirm);
   };
   var ParsedMove = F2(function (a,
   b) {
      return {_: {}
             ,legal: a
             ,move: b};
   });
   var handleLegalMove = F2(function (_v3,
   state) {
      return function () {
         return function () {
            var $ = _v3.move,
            from = $._0,
            to = $._1;
            var $ = state,
            turn = $.turn,
            pieces = $.pieces;
            var mightMove = A2(Model.findPiece,
            pieces,
            from);
            return Basics.not(_v3.legal) ? _U.replace([["moved"
                                                       ,false]],
            state) : {_: {}
                     ,moved: true
                     ,pieces: A3(Moving.makeMove,
                     mightMove,
                     pieces,
                     to)
                     ,selected: Maybe.Nothing
                     ,turn: toggleTurn(turn)};
         }();
      }();
   });
   var selectPiece = F2(function (state,
   clickPos) {
      return _U.replace([["selected"
                         ,state.moved ? Maybe.Nothing : A2(Model.findPiece,
                         state.pieces,
                         clickPos)]],
      state);
   });
   var encodeMove = function (_v5) {
      return function () {
         switch (_v5.ctor)
         {case "_Tuple2": return {_: {}
                                 ,from: Parser.pos2String(_v5._0)
                                 ,to: Parser.pos2String(_v5._1)};}
         _E.Case($moduleName,
         "on line 31, column 6 to 48");
      }();
   };
   var stail = function ($) {
      return String.fromList(List.tail(String.toList($)));
   };
   var initialMove = {ctor: "_Tuple2"
                     ,_0: {ctor: "_Tuple2"
                          ,_0: _U.chr("h")
                          ,_1: 11}
                     ,_1: {ctor: "_Tuple2"
                          ,_0: _U.chr("h")
                          ,_1: 11}};
   var initialConfirmation = {_: {}
                             ,legal: false
                             ,move: encodeMove(initialMove)};
   var updateMove = F2(function (position,
   _v9) {
      return function () {
         switch (_v9.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: _v9._1
                   ,_1: position};}
         _E.Case($moduleName,
         "on line 23, column 35 to 47");
      }();
   });
   var choosePos = F3(function (player,
   redPos,
   blackPos) {
      return function () {
         switch (player.ctor)
         {case "Black": return blackPos;
            case "Red": return redPos;}
         _E.Case($moduleName,
         "between lines 18 and 20");
      }();
   });
   var makeClicks = function (color) {
      return function () {
         var playerColor = A2(Signal.lift,
         Model.playerADT,
         color);
         var mousePosition = A4(Signal.lift3,
         choosePos,
         playerColor,
         Input.redBoardPosition,
         Input.blackBoardPosition);
         return A2(Signal.sampleOn,
         Mouse.clicks,
         mousePosition);
      }();
   };
   var makeMoves = function (_v14) {
      return function () {
         return function () {
            var clickPosition = makeClicks(_v14.color);
            var boardMoves = A3(Signal.foldp,
            updateMove,
            initialMove,
            clickPosition);
            return A2(Signal.lift,
            encodeMove,
            boardMoves);
         }();
      }();
   };
   var initialState = {_: {}
                      ,check: Maybe.Nothing
                      ,moved: false
                      ,pieces: Model.allPieces
                      ,selected: Maybe.Nothing
                      ,turn: Model.Red};
   var makeGame = function (_v16) {
      return function () {
         return function () {
            var clickPosition = makeClicks(_v16.color);
            var boardMoves = A2(Signal.lift,
            convertMoveRecord,
            _v16.moves);
            var onlyMoves = A3(Signal.foldp,
            handleLegalMove,
            initialState,
            boardMoves);
            var withSelected = A3(Signal.lift2,
            selectPiece,
            onlyMoves,
            clickPosition);
            return A3(Signal.lift2,
            addCheckToState,
            withSelected,
            _v16.checkStatus);
         }();
      }();
   };
   _elm.GameState.values = {_op: _op
                           ,initialState: initialState
                           ,choosePos: choosePos
                           ,updateMove: updateMove
                           ,initialMove: initialMove
                           ,initialConfirmation: initialConfirmation
                           ,stail: stail
                           ,encodeMove: encodeMove
                           ,makeClicks: makeClicks
                           ,makeMoves: makeMoves
                           ,selectPiece: selectPiece
                           ,handleLegalMove: handleLegalMove
                           ,convertMoveRecord: convertMoveRecord
                           ,toggleTurn: toggleTurn
                           ,calculateCheck: calculateCheck
                           ,addCheckToState: addCheckToState
                           ,makeGame: makeGame
                           ,ParsedMove: ParsedMove};
   return _elm.GameState.values;
};Elm.Parser = Elm.Parser || {};
Elm.Parser.make = function (_elm) {
   _elm.Parser = _elm.Parser || {};
   if (_elm.Parser.values)
   return _elm.Parser.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _E = _N.Error.make(_elm),
   _J = _N.JavaScript.make(_elm),
   $moduleName = "Parser";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Constants = Elm.Constants.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var JavaScript = JavaScript || {};
   JavaScript.Experimental = Elm.JavaScript.Experimental.make(_elm);
   var Json = Elm.Json.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Model = Elm.Model.make(_elm);
   var Monad = Elm.Monad.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Prelude = Elm.Prelude.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var encodeColor = function (color) {
      return function () {
         switch (color.ctor)
         {case "Black": return "black";
            case "Red": return "red";}
         _E.Case($moduleName,
         "between lines 76 and 78");
      }();
   };
   var type2String = function (adt) {
      return function () {
         switch (adt.ctor)
         {case "Advisor":
            return "Advisor";
            case "Cannon": return "Cannon";
            case "Chariot":
            return "Chariot";
            case "Elephant":
            return "Elephant";
            case "Horse": return "Horse";
            case "King": return "King";
            case "Soldier":
            return "Soldier";}
         _E.Case($moduleName,
         "between lines 66 and 73");
      }();
   };
   var int2Str = function ($int) {
      return function () {
         switch ($int)
         {case 0: return "0";
            case 1: return "1";
            case 2: return "2";
            case 3: return "3";
            case 4: return "4";
            case 5: return "5";
            case 6: return "6";
            case 7: return "7";
            case 8: return "8";
            case 9: return "9";
            case 10: return "10";}
         return "11";
      }();
   };
   var unpack = function (option) {
      return function () {
         switch (option.ctor)
         {case "Just": return option._0;
            case "Nothing": return -1;}
         _E.Case($moduleName,
         "between lines 26 and 28");
      }();
   };
   var chars2Pos = function (chars) {
      return function () {
         var numStr = String.fromList(A2(List.drop,
         2,
         chars));
         var number = unpack(String.toInt(numStr));
         var colStr = String.fromList(A2(List.take,
         1,
         chars));
         var col = unpack(String.toInt(colStr));
         var $char = Constants.num2Char(col);
         return {ctor: "_Tuple2"
                ,_0: $char
                ,_1: number + 1};
      }();
   };
   var string2Pos = function ($) {
      return chars2Pos(String.toList($));
   };
   var pos2String = function (pair) {
      return function () {
         var $ = pair,
         col = $._0,
         $int = $._1;
         var row = int2Str($int - 1);
         var intCol = function ($) {
            return int2Str(Constants.char2Num($));
         }(col);
         return F2(function (x,y) {
            return _L.append(x,y);
         })(intCol)(A2(String.cons,
         _U.chr(","),
         row));
      }();
   };
   var piece2List = function (_v5) {
      return function () {
         switch (_v5.ctor)
         {case "Piece":
            return function () {
                 var strColor = encodeColor(_v5._2);
                 var strPos = pos2String(_v5._1);
                 var strType = type2String(_v5._0);
                 return _J.toList([strType
                                  ,strPos
                                  ,strColor]);
              }();}
         _E.Case($moduleName,
         "between lines 60 and 63");
      }();
   };
   var decodeMove = function (message) {
      return function () {
         var $ = message,
         from = $.from,
         to = $.to;
         var start = string2Pos(from);
         var end = string2Pos(to);
         return {ctor: "_Tuple2"
                ,_0: start
                ,_1: end};
      }();
   };
   var Metadata = F2(function (a,
   b) {
      return {_: {}
             ,gameId: a
             ,player: b};
   });
   _elm.Parser.values = {_op: _op
                        ,decodeMove: decodeMove
                        ,pos2String: pos2String
                        ,unpack: unpack
                        ,chars2Pos: chars2Pos
                        ,string2Pos: string2Pos
                        ,int2Str: int2Str
                        ,piece2List: piece2List
                        ,type2String: type2String
                        ,encodeColor: encodeColor
                        ,Metadata: Metadata};
   return _elm.Parser.values;
};Elm.Moving = Elm.Moving || {};
Elm.Moving.make = function (_elm) {
   _elm.Moving = _elm.Moving || {};
   if (_elm.Moving.values)
   return _elm.Moving.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _E = _N.Error.make(_elm),
   _J = _N.JavaScript.make(_elm),
   $moduleName = "Moving";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Model = Elm.Model.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Prelude = Elm.Prelude.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var remove = F2(function (list,
   element) {
      return A2(List.filter,
      function (e) {
         return Basics.not(_U.eq(e,
         element));
      },
      list);
   });
   var move = function (_v0) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple3":
            switch (_v0._0.ctor)
              {case "Piece":
                 return function () {
                      var newPiece = A3(Model.Piece,
                      _v0._0._0,
                      _v0._2,
                      _v0._0._2);
                      var removedOld = A2(remove,
                      _v0._1,
                      A3(Model.Piece,
                      _v0._0._0,
                      _v0._0._1,
                      _v0._0._2));
                      var option = A2(Model.findPiece,
                      removedOld,
                      _v0._2);
                      var removeCaptured = function () {
                         switch (option.ctor)
                         {case "Just": return A2(remove,
                              removedOld,
                              option._0);
                            case "Nothing":
                            return removedOld;}
                         _E.Case($moduleName,
                         "between lines 16 and 19");
                      }();
                      return {ctor: "::"
                             ,_0: newPiece
                             ,_1: removeCaptured};
                   }();}
              break;}
         _E.Case($moduleName,
         "between lines 13 and 19");
      }();
   };
   var makeMove = F3(function (option,
   pieces,
   position) {
      return function () {
         switch (option.ctor)
         {case "Just":
            return move({ctor: "_Tuple3"
                        ,_0: option._0
                        ,_1: pieces
                        ,_2: position});
            case "Nothing": return pieces;}
         _E.Case($moduleName,
         "between lines 24 and 27");
      }();
   });
   _elm.Moving.values = {_op: _op
                        ,remove: remove
                        ,move: move
                        ,makeMove: makeMove};
   return _elm.Moving.values;
};Elm.Input = Elm.Input || {};
Elm.Input.make = function (_elm) {
   _elm.Input = _elm.Input || {};
   if (_elm.Input.values)
   return _elm.Input.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _E = _N.Error.make(_elm),
   _J = _N.JavaScript.make(_elm),
   $moduleName = "Input";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Constants = Elm.Constants.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var JavaScript = Elm.JavaScript.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Model = Elm.Model.make(_elm);
   var Mouse = Elm.Mouse.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Prelude = Elm.Prelude.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var Window = Elm.Window.make(_elm);
   var _op = {};
   var widthOffset = 20;
   var toBoardColumn = F2(function (player,
   pixels) {
      return function () {
         switch (player.ctor)
         {case "Black":
            return function () {
                 var newWidth = Constants.boardWidth + widthOffset;
                 var converted = newWidth - pixels;
                 return Constants.num2Char(A2(Basics.div,
                 converted,
                 Constants.squareSize));
              }();
            case "Red":
            return Constants.num2Char(A2(Basics.div,
              pixels + widthOffset,
              Constants.squareSize));}
         _E.Case($moduleName,
         "between lines 24 and 28");
      }();
   });
   var heightOffset = 12;
   var toBoardRow = F2(function (player,
   pixels) {
      return function () {
         switch (player.ctor)
         {case "Black":
            return function () {
                 var blackOffset = heightOffset * 2;
                 var newPixels = pixels + blackOffset;
                 return A2(Basics.div,
                 newPixels,
                 Constants.squareSize) + 1;
              }();
            case "Red": return function () {
                 var newHeight = Constants.boardHeight + heightOffset;
                 var converted = newHeight - pixels;
                 return A2(Basics.div,
                 converted,
                 Constants.squareSize) + 1;
              }();}
         _E.Case($moduleName,
         "between lines 16 and 22");
      }();
   });
   var toBoardPosition = F2(function (player,
   _v2) {
      return function () {
         switch (_v2.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: A2(toBoardColumn,
                   player,
                   _v2._0)
                   ,_1: A2(toBoardRow,
                   player,
                   _v2._1)};}
         _E.Case($moduleName,
         "on line 30, column 34 to 77");
      }();
   });
   var toBoardPixels = F3(function (_v6,
   w,
   h) {
      return function () {
         switch (_v6.ctor)
         {case "_Tuple2":
            return function () {
                 var xToBoard = (w - (Constants.boardWidth + Constants.sideBarWidth)) / 2 | 0;
                 var yToBoard = (h - Constants.boardHeight) / 2 | 0;
                 return {ctor: "_Tuple2"
                        ,_0: _v6._0 - xToBoard
                        ,_1: _v6._1 - yToBoard};
              }();}
         _E.Case($moduleName,
         "between lines 8 and 10");
      }();
   });
   var boardPixels = A4(Signal.lift3,
   toBoardPixels,
   Mouse.position,
   Window.width,
   Window.height);
   var redBoardPosition = A2(Signal.lift,
   toBoardPosition(Model.Red),
   boardPixels);
   var blackBoardPosition = A2(Signal.lift,
   toBoardPosition(Model.Black),
   boardPixels);
   _elm.Input.values = {_op: _op
                       ,redBoardPosition: redBoardPosition
                       ,blackBoardPosition: blackBoardPosition};
   return _elm.Input.values;
};Elm.Model = Elm.Model || {};
Elm.Model.make = function (_elm) {
   _elm.Model = _elm.Model || {};
   if (_elm.Model.values)
   return _elm.Model.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _E = _N.Error.make(_elm),
   _J = _N.JavaScript.make(_elm),
   $moduleName = "Model";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Constants = Elm.Constants.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Prelude = Elm.Prelude.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var State = F5(function (a,
   b,
   c,
   d,
   e) {
      return {_: {}
             ,check: e
             ,moved: d
             ,pieces: b
             ,selected: c
             ,turn: a};
   });
   var CheckMate = function (a) {
      return {ctor: "CheckMate"
             ,_0: a};
   };
   var Check = function (a) {
      return {ctor: "Check",_0: a};
   };
   var Piece = F3(function (a,
   b,
   c) {
      return {ctor: "Piece"
             ,_0: a
             ,_1: b
             ,_2: c};
   });
   var findPiece = F2(function (pieces,
   position) {
      return function () {
         switch (pieces.ctor)
         {case "::":
            switch (pieces._0.ctor)
              {case "Piece":
                 return _U.eq(position,
                   pieces._0._1) ? Maybe.Just(A3(Piece,
                   pieces._0._0,
                   pieces._0._1,
                   pieces._0._2)) : A2(findPiece,
                   pieces._1,
                   position);}
              break;
            case "[]":
            return Maybe.Nothing;}
         _E.Case($moduleName,
         "between lines 41 and 45");
      }();
   });
   var Black = {ctor: "Black"};
   var makeBlack = function (_v6) {
      return function () {
         switch (_v6.ctor)
         {case "Piece":
            switch (_v6._1.ctor)
              {case "_Tuple2":
                 return A3(Piece,
                   _v6._0,
                   {ctor: "_Tuple2"
                   ,_0: _v6._1._0
                   ,_1: 11 - _v6._1._1},
                   Black);}
              break;}
         _E.Case($moduleName,
         "on line 34, column 39 to 71");
      }();
   };
   var Red = {ctor: "Red"};
   var piece = function (_v13) {
      return function () {
         switch (_v13.ctor)
         {case "_Tuple2":
            return A3(Piece,
              _v13._0,
              {ctor: "_Tuple2"
              ,_0: _v13._1
              ,_1: 1},
              Red);}
         _E.Case($moduleName,
         "on line 29, column 22 to 46");
      }();
   };
   var playerADT = function (color) {
      return function () {
         switch (color)
         {case "black": return Black;
            case "red": return Red;}
         return Red;
      }();
   };
   var King = {ctor: "King"};
   var Chariot = {ctor: "Chariot"};
   var Cannon = {ctor: "Cannon"};
   var cannons = A2(List.map,
   function (c) {
      return A3(Piece,
      Cannon,
      {ctor: "_Tuple2",_0: c,_1: 3},
      Red);
   },
   _J.toList([_U.chr("b")
             ,_U.chr("h")]));
   var Horse = {ctor: "Horse"};
   var Elephant = {ctor: "Elephant"};
   var Advisor = {ctor: "Advisor"};
   var typeOrder = _J.toList([Chariot
                             ,Horse
                             ,Elephant
                             ,Advisor]);
   var fullTypes = List.concat(_J.toList([typeOrder
                                         ,{ctor: "::"
                                          ,_0: King
                                          ,_1: List.reverse(typeOrder)}]));
   var typesWithChars = A2(List.zip,
   fullTypes,
   Constants.allLetters);
   var rest = A2(List.map,
   piece,
   typesWithChars);
   var Soldier = {ctor: "Soldier"};
   var soldier = function ($char) {
      return A3(Piece,
      Soldier,
      {ctor: "_Tuple2"
      ,_0: $char
      ,_1: 4},
      Red);
   };
   var soldiers = A2(List.map,
   soldier,
   Constants.soldierLetters);
   var redPieces = List.concat(_J.toList([soldiers
                                         ,cannons
                                         ,rest]));
   var blackPieces = A2(List.map,
   makeBlack,
   redPieces);
   var allPieces = List.concat(_J.toList([redPieces
                                         ,blackPieces]));
   _elm.Model.values = {_op: _op
                       ,soldier: soldier
                       ,soldiers: soldiers
                       ,cannons: cannons
                       ,typeOrder: typeOrder
                       ,fullTypes: fullTypes
                       ,typesWithChars: typesWithChars
                       ,piece: piece
                       ,rest: rest
                       ,redPieces: redPieces
                       ,makeBlack: makeBlack
                       ,blackPieces: blackPieces
                       ,allPieces: allPieces
                       ,findPiece: findPiece
                       ,playerADT: playerADT
                       ,Soldier: Soldier
                       ,Advisor: Advisor
                       ,Elephant: Elephant
                       ,Horse: Horse
                       ,Cannon: Cannon
                       ,Chariot: Chariot
                       ,King: King
                       ,Red: Red
                       ,Black: Black
                       ,Piece: Piece
                       ,Check: Check
                       ,CheckMate: CheckMate
                       ,State: State};
   return _elm.Model.values;
};Elm.Constants = Elm.Constants || {};
Elm.Constants.make = function (_elm) {
   _elm.Constants = _elm.Constants || {};
   if (_elm.Constants.values)
   return _elm.Constants.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _E = _N.Error.make(_elm),
   _J = _N.JavaScript.make(_elm),
   $moduleName = "Constants";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Prelude = Elm.Prelude.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var soldierLetters = _J.toList([_U.chr("a")
                                  ,_U.chr("c")
                                  ,_U.chr("e")
                                  ,_U.chr("g")
                                  ,_U.chr("i")]);
   var allLetters = _J.toList([_U.chr("a")
                              ,_U.chr("b")
                              ,_U.chr("c")
                              ,_U.chr("d")
                              ,_U.chr("e")
                              ,_U.chr("f")
                              ,_U.chr("g")
                              ,_U.chr("h")
                              ,_U.chr("i")]);
   var allColumns = allLetters;
   var range = F2(function (min,
   max) {
      return _U.cmp(min,
      max) < 0 ? {ctor: "::"
                 ,_0: min
                 ,_1: A2(range,
                 min + 1,
                 max)} : _J.toList([]);
   });
   var allRows = A2(range,1,10);
   var num2Char = function (num) {
      return function () {
         switch (num)
         {case 0: return _U.chr("a");
            case 1: return _U.chr("b");
            case 2: return _U.chr("c");
            case 3: return _U.chr("d");
            case 4: return _U.chr("e");
            case 5: return _U.chr("f");
            case 6: return _U.chr("g");
            case 7: return _U.chr("h");
            case 8: return _U.chr("i");}
         return _U.chr("a");
      }();
   };
   var char2Num = function ($char) {
      return function () {
         switch ($char + "")
         {case "a": return 0;
            case "b": return 1;
            case "c": return 2;
            case "d": return 3;
            case "e": return 4;
            case "f": return 5;
            case "g": return 6;
            case "h": return 7;
            case "i": return 8;}
         return 0;
      }();
   };
   var half = function (x) {
      return A2(Basics.div,x,2);
   };
   var twoThirds = function (x) {
      return x - A2(Basics.div,
      x,
      3);
   };
   var folder = "assets";
   var imageName = _L.append(folder,
   "/board.jpg");
   var imageFileSize = _J.toList([669
                                 ,749]);
   var boardSize = A2(List.map,
   twoThirds,
   imageFileSize);
   var $ = boardSize;
   var boardHeight = function () {
      switch ($.ctor)
      {case "::": switch ($._1.ctor)
           {case "::":
              switch ($._1._1.ctor)
                {case "[]": return $._1._0;}
                break;}
           break;}
      _E.Case($moduleName,
      "on line 16, column 29 to 38");
   }();
   var boardWidth = function () {
      switch ($.ctor)
      {case "::": switch ($._1.ctor)
           {case "::":
              switch ($._1._1.ctor)
                {case "[]": return $._0;}
                break;}
           break;}
      _E.Case($moduleName,
      "on line 16, column 29 to 38");
   }();
   var boardImage = A3(Graphics.Element.image,
   boardWidth,
   boardHeight,
   imageName);
   var squareSize = A2(Basics.div,
   boardWidth,
   8);
   var $ = A2(List.map,
   half,
   boardSize);
   var centerHeight = function () {
      switch ($.ctor)
      {case "::": switch ($._1.ctor)
           {case "::":
              switch ($._1._1.ctor)
                {case "[]": return $._1._0;}
                break;}
           break;}
      _E.Case($moduleName,
      "on line 18, column 31 to 49");
   }();
   var centerWidth = function () {
      switch ($.ctor)
      {case "::": switch ($._1.ctor)
           {case "::":
              switch ($._1._1.ctor)
                {case "[]": return $._0;}
                break;}
           break;}
      _E.Case($moduleName,
      "on line 18, column 31 to 49");
   }();
   var sideBarWidth = 200;
   _elm.Constants.values = {_op: _op
                           ,sideBarWidth: sideBarWidth
                           ,imageFileSize: imageFileSize
                           ,folder: folder
                           ,imageName: imageName
                           ,twoThirds: twoThirds
                           ,half: half
                           ,boardSize: boardSize
                           ,boardHeight: boardHeight
                           ,boardWidth: boardWidth
                           ,boardImage: boardImage
                           ,centerHeight: centerHeight
                           ,centerWidth: centerWidth
                           ,squareSize: squareSize
                           ,char2Num: char2Num
                           ,num2Char: num2Char
                           ,allRows: allRows
                           ,range: range
                           ,allColumns: allColumns
                           ,allLetters: allLetters
                           ,soldierLetters: soldierLetters};
   return _elm.Constants.values;
};Elm.Monad = Elm.Monad || {};
Elm.Monad.make = function (_elm) {
   _elm.Monad = _elm.Monad || {};
   if (_elm.Monad.values)
   return _elm.Monad.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _E = _N.Error.make(_elm),
   _J = _N.JavaScript.make(_elm),
   $moduleName = "Monad";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Prelude = Elm.Prelude.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var flatmap = F2(function (fn,
   monad) {
      return function () {
         switch (monad.ctor)
         {case "Just":
            return fn(monad._0);
            case "Nothing":
            return Maybe.Nothing;}
         _E.Case($moduleName,
         "between lines 16 and 18");
      }();
   });
   var filter = F2(function (fn,
   monad) {
      return function () {
         switch (monad.ctor)
         {case "Just":
            return fn(monad._0) ? monad : Maybe.Nothing;
            case "Nothing":
            return Maybe.Nothing;}
         _E.Case($moduleName,
         "between lines 10 and 12");
      }();
   });
   var map = F2(function (fn,
   monad) {
      return A2(flatmap,
      function (v) {
         return Maybe.Just(fn(v));
      },
      monad);
   });
   _elm.Monad.values = {_op: _op
                       ,map: map
                       ,filter: filter
                       ,flatmap: flatmap};
   return _elm.Monad.values;
};