;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname Lazarevski_Bojan_PF1_Project) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;;;;;;;;;;;;;;;;;;;;;;;;; 
; Chess - Final Project ;
;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Done by:
; - Genaro Di Stefano;
; - Harkeerat Singh Sawhney;
; - Bojan Lazarevski.
; As a part of the final project of the course Programming Fundamentals 1, 2020, USI.

; Please read the following files in the directory named "Chess" before starting the application:
; - "User Guide" - Understand how the program works and how to run it;
; - "Developer Guide" - Understand how the source files and functions work;
; Optional: "Change Summary" - Changes introduced after the submission of the project proposal.

; DrRacket Student Language used:
; - Advanced Student

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;
; Libraries ;
;;;;;;;;;;;;;

(require racket/base) ; - Used for the ability to do the command struct-copy
(require 2htdp/image) ; - Used for building and constructing images
(require 2htdp/universe) ; - Used for the big-bang function

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; If you encounter -b or -w appended to a constant/function/definition name that means -black or -white respectively
; i.e the player/piece side on the chessboard

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Data Types and Constants ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A BoardPosition is a Structure (make-boardpos x y) where:
; - x, y are a non-negative Integer between 1 and 8 (1 <= x, y <= 8)
; Interpretation: It represents a position/coordinate on the chessboard;
(define-struct boardpos [x y] #:transparent)

; Data Examples for the structure BoardPosition:
(define A1 (make-boardpos 1 1)) (define A2 (make-boardpos 1 2)) (define A3 (make-boardpos 1 3)) (define A4 (make-boardpos 1 4))
(define A5 (make-boardpos 1 5)) (define A6 (make-boardpos 1 6)) (define A7 (make-boardpos 1 7)) (define A8 (make-boardpos 1 8))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define B1 (make-boardpos 2 1)) (define B2 (make-boardpos 2 2)) (define B3 (make-boardpos 2 3)) (define B4 (make-boardpos 2 4))
(define B5 (make-boardpos 2 5)) (define B6 (make-boardpos 2 6)) (define B7 (make-boardpos 2 7)) (define B8 (make-boardpos 2 8))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define C1 (make-boardpos 3 1)) (define C2 (make-boardpos 3 2)) (define C3 (make-boardpos 3 3)) (define C4 (make-boardpos 3 4))
(define C5 (make-boardpos 3 5)) (define C6 (make-boardpos 3 6)) (define C7 (make-boardpos 3 7)) (define C8 (make-boardpos 3 8))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define D1 (make-boardpos 4 1)) (define D2 (make-boardpos 4 2)) (define D3 (make-boardpos 4 3)) (define D4 (make-boardpos 4 4))
(define D5 (make-boardpos 4 5)) (define D6 (make-boardpos 4 6)) (define D7 (make-boardpos 4 7)) (define D8 (make-boardpos 4 8))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define E1 (make-boardpos 5 1)) (define E2 (make-boardpos 5 2)) (define E3 (make-boardpos 5 3)) (define E4 (make-boardpos 5 4))
(define E5 (make-boardpos 5 5)) (define E6 (make-boardpos 5 6)) (define E7 (make-boardpos 5 7)) (define E8 (make-boardpos 5 8))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define F1 (make-boardpos 6 1)) (define F2 (make-boardpos 6 2)) (define F3 (make-boardpos 6 3)) (define F4 (make-boardpos 6 4))
(define F5 (make-boardpos 6 5)) (define F6 (make-boardpos 6 6)) (define F7 (make-boardpos 6 7)) (define F8 (make-boardpos 6 8))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define G1 (make-boardpos 7 1)) (define G2 (make-boardpos 7 2)) (define G3 (make-boardpos 7 3)) (define G4 (make-boardpos 7 4))
(define G5 (make-boardpos 7 5)) (define G6 (make-boardpos 7 6)) (define G7 (make-boardpos 7 7)) (define G8 (make-boardpos 7 8))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define H1 (make-boardpos 8 1)) (define H2 (make-boardpos 8 2)) (define H3 (make-boardpos 8 3)) (define H4 (make-boardpos 8 4))
(define H5 (make-boardpos 8 5)) (define H6 (make-boardpos 8 6)) (define H7 (make-boardpos 8 7)) (define H8 (make-boardpos 8 8))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A Path is a String and can be one of the following:
; - "up"
; - "down"
; - "left"
; - "right"
; Interpretation: A path/direction on the chessboard;

; A Piece is a Structure (make-piece type position side) where:
; - type : The type of the chess piece represented in string;
; - position : The position of the piece on the chessboard represented in posn;
; - side: The piece side represented by its color in string.
(define-struct piece [type position side])

; Data Examples for the structure Piece:

;;;;;;;;
; Pawn ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define PAWN-1w (make-piece "pawn" A7 "white"))
(define PAWN-2w (make-piece "pawn" B7 "white"))
(define PAWN-3w (make-piece "pawn" C7 "white"))
(define PAWN-4w (make-piece "pawn" D7 "white"))
(define PAWN-5w (make-piece "pawn" E7 "white"))
(define PAWN-6w (make-piece "pawn" F7 "white"))
(define PAWN-7w (make-piece "pawn" G7 "white"))
(define PAWN-8w (make-piece "pawn" H7 "white"))
(define PAWN-1b (make-piece "pawn" A2 "black"))
(define PAWN-2b (make-piece "pawn" B2 "black"))
(define PAWN-3b (make-piece "pawn" C2 "black"))
(define PAWN-4b (make-piece "pawn" D2 "black"))
(define PAWN-5b (make-piece "pawn" E2 "black"))
(define PAWN-6b (make-piece "pawn" F2 "black"))
(define PAWN-7b (make-piece "pawn" G2 "black"))
(define PAWN-8b (make-piece "pawn" H2 "black"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rook ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define ROOK-1w (make-piece "rook" A8 "white"))
(define ROOK-2w (make-piece "rook" H8 "white"))
(define ROOK-1b (make-piece "rook" A1 "black"))
(define ROOK-2b (make-piece "rook" H1 "black"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Horse ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define HORSE-1w (make-piece "horse" B8 "white"))
(define HORSE-2w (make-piece "horse" G8 "white"))
(define HORSE-1b (make-piece "horse" B1 "black"))
(define HORSE-2b (make-piece "horse" G1 "black"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Bishop ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define BISHOP-1w (make-piece "bishop" C8 "white"))
(define BISHOP-2w (make-piece "bishop" F8 "white"))
(define BISHOP-1b (make-piece "bishop" C1 "black"))
(define BISHOP-2b (make-piece "bishop" F1 "black"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Queen ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define QUEEN-1w (make-piece "queen" D8 "white"))
(define QUEEN-1b (make-piece "queen" D1 "black"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; King ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define KING-1w (make-piece "king" E8 "white"))
(define KING-1b (make-piece "king" E1 "black"))

; An AppState is a Struct (make-appstate lop pos1 pos2 select1 select2 current go) where:
; - lop : List of pieces displayed on the chessboard;
; - pos1, pos2 : Position of player 1 and player 2 respectively;
; - select1, select2 : Boolean
; - current : String which is one of the following:
;        ; - "player1"
;        ; - "player2"
;        ; - "mainmenu"
;        ; - "victory1"
;        ; - "victory2"
;        ; - "victory3" - Victory for AI Bot, if time permits
;        ; - "draw" - Not yet defined, if time permits
; - go : Position;
(define-struct appstate [lop pos1 pos2 select1 select2 current go] #:transparent)

;;;;;;;;;;;;;;;;;;;;;;;;
; List of Pieces (lop) ;
;;;;;;;;;;;;;;;;;;;;;;;;
(define LOP (list PAWN-1w
                  PAWN-2w
                  PAWN-3w
                  PAWN-4w
                  PAWN-5w
                  PAWN-6w
                  PAWN-7w
                  PAWN-8w
                  PAWN-1b
                  PAWN-2b
                  PAWN-3b
                  PAWN-4b
                  PAWN-5b
                  PAWN-6b
                  PAWN-7b
                  PAWN-8b
                  ROOK-1w
                  ROOK-2w
                  ROOK-1b
                  ROOK-2b
                  HORSE-1w
                  HORSE-2w
                  HORSE-1b
                  HORSE-2b
                  BISHOP-1w
                  BISHOP-2w
                  BISHOP-1b
                  BISHOP-2b
                  QUEEN-1w
                  QUEEN-1b
                  KING-1w
                  KING-1b))

; Data Examples for the struct AppState:
(define ST1 (make-appstate LOP
                           A5
                           H8
                           #f
                           #f
                           "player2"
                           A2))

(define ST2 (make-appstate LOP
                           A1
                           G1
                           #t
                           #f
                           "player1"
                           B3))

(define STATE (make-appstate LOP
                             E8 
                             E1
                             #f
                             #f
                             "player1"
                             A1))

(define STATE-BEGIN (make-appstate LOP
                                   E8
                                   E1
                                   #f
                                   #f
                                   "mainmenu"
                                   A1))

;;;;;;;;;;;;;;;;;;;;;;;
; Chessboard Elements ;
;;;;;;;;;;;;;;;;;;;;;;;

; Chessboard Dimensions:
(define WIDTH 800)

; Predifined struct for custom color
(struct	color (red green blue alpha))

; Chess Blocks
(define BLOCK-w (square 100 "solid" "black")) ; Not Used
(define BLOCK-b (square 100 "solid" "black"))
(define BLOCK-SELECT-w (square 100 "outline" (pen (make-color 122 242 24) 3 "solid" "round" "bevel")))
(define BLOCK-SELECT-b (square 100 "outline" (pen (make-color 76 242 236) 3 "solid" "round" "bevel")))
(define BLOCK-ACTIVE-w (square 100 "outline" (pen (make-color 50 104 6) 3 "solid" "round" "round")))
(define BLOCK-ACTIVE-b (square 100 "outline" (pen (make-color 42 119 116) 3 "solid" "round" "round")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: draw-row
; I/O: BoardPosn Image -> Image
; Interpretation: Draws one row of blocks in the chessboard

; Header:
; (define (draw-row position image) (square 1 "solid" "black"))

; Examples:
(check-expect (draw-row A1 BLOCK-b) BLOCK-b)
(check-expect (draw-row B7 BLOCK-w) BLOCK-w)

; Template:
; (define (draw-row position image)
;  (cond
;   [(... (... position)) image]
;   [else
;     (place-image ...
;                  (... position)
;                  (... position)
;                  (draw-row (... position ...) image))]))

; Code
(define (draw-row position image)
  (cond
    [(< 8 (boardpos-x position)) image]
    [else
     (place-image BLOCK-b
                  (blockpos-x position)
                  (blockpos-y position)
                  (draw-row (make-boardpos (+ 2 (boardpos-x position)) (boardpos-y position)) image))]))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: draw-chessboard
; I/O: Non-negative_Integer Image -> Image;
; Interpretation: Draws the chessboard with all rows and columns

; Header:
; (define (draw-chessboard int image) (square 1 "solid" "black")

; Template:
; (define (draw-chessboard int image)
; (cond
;  [(... int) image[
;  [... int ...]
;   (draw-chessboard ... int ... (draw-row ... image))]
;  [else
;   (draw-chessboard ... int ... (draw-row ... image))]

; Code:
(define (draw-chessboard int image)
  (cond
    [(< 8 int) image]
    [(member int (list 2 4 6 8))
     (draw-chessboard (add1 int) (draw-row (make-boardpos 0 int) image))]
    [else
     (draw-chessboard (add1 int) (draw-row (make-boardpos 1 int) image))]))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: draw-select
; I/O: AppState Image -> Image
; Interpretation: Draws the players selectors on a given chessboard image

; Header:
; (define (draw-select st image) (square 1 "solid" "black"))

; Template:
;(define (draw-select st image)
;  (local ((define blockpos-x.pos1 (blockpos-x (appstate-pos1 st)))
;          (define blockpos-y.pos1 (blockpos-y (appstate-pos1 st)))
;          (define blockpos-x.pos2 (blockpos-x (appstate-pos2 st)))
;          (define blockpos-y.pos2 (blockpos-y (appstate-pos2 st)))
;          (define blockpos-x.go (blockpos-x (appstate-go st)))
;          (define blockpos-y.go (blockpos-y (appstate-go st))))
;  (if (... (appstate-current st))
;      (if (appstate-select1 st)
;          (place-image ...
;                       blockpos-x.pos1
;                       blockpos-y.pos1
;                       (place-image BLOCK-ACTIVE-w
;                                    blockpos-x.go
;                                    blockpos-y.go
;                                    image))
;      (if (appstate-select2 st)
;          (place-image ...
;                       blockpos-x.pos2
;                       blockpos-y.pos2
;                       (place-image ...
;                                    blockpos-x.go
;                                    blockpos-y.go
;                                    image))

; Code:
(define (draw-select st image)
  (local ((define blockpos-x.pos1 (blockpos-x (appstate-pos1 st)))
          (define blockpos-y.pos1 (blockpos-y (appstate-pos1 st)))
          (define blockpos-x.pos2 (blockpos-x (appstate-pos2 st)))
          (define blockpos-y.pos2 (blockpos-y (appstate-pos2 st)))
          (define blockpos-x.go (blockpos-x (appstate-go st)))
          (define blockpos-y.go (blockpos-y (appstate-go st))))
  (if (string=? "player1" (appstate-current st))
      (if (appstate-select1 st)
          (place-image BLOCK-ACTIVE-w
                       blockpos-x.pos1
                       blockpos-y.pos1
                       (place-image BLOCK-ACTIVE-w
                                    blockpos-x.go
                                    blockpos-y.go
                                    image))
          (place-image BLOCK-SELECT-w
                       blockpos-x.pos1
                       blockpos-y.pos1
                       image))
      (if (appstate-select2 st)
          (place-image BLOCK-ACTIVE-b
                       blockpos-x.pos2
                       blockpos-y.pos2
                       (place-image BLOCK-ACTIVE-b
                                    blockpos-x.go
                                    blockpos-y.go
                                    image))
          (place-image BLOCK-SELECT-b
                       blockpos-x.pos2
                       blockpos-y.pos2
                       image)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: draw-piece
; I/O: Piece Image -> Image
; Interpretation: Draws a chess piece, an image file, on a given chessboard image

; Header:
; (define draw-piece piece image) (square 1 "solid" "black")

; Template:
; (define (draw-piece piece image)
;   (local [(define source (string-append "img/"
;                                         (piece-side piece)
;                                         (piece-side piece)
;                                         ".png"))]
;   (place-image (if (... WIDTH ...)
;                    (bitmap/file source)
;                    (... (... WIDTH)
;                         (... (bitmap/file source))
;                    (bitmap/file source)))
;                (blockpos-x (... piece))
;                (blockpos-y (... piece))
;                image)))

; Code:
(define (draw-piece piece image)
  (local [(define source (string-append "img/"
                                        (piece-side piece) ; black/white
                                        (piece-type piece) ; pawn/rook/horse/bishop/queen/king
                                        ".png"))] ; Takes the relative path of the chess pieces
    (place-image (if (= WIDTH 800)
                     (bitmap/file source)
                     (scale (/ (/ WIDTH 8)
                               (image-width (bitmap/file source)))
                            (bitmap/file source)))
                 (blockpos-x (piece-position piece))
                 (blockpos-y (piece-position piece))
                 image)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: draw-piece.lop
; I/O: List<Piece> Image -> Image
; Interpretation: Draws a list of pieces on a given chessboard image

; Header:
; (define (draw-piece.lop lop image) (square 1 "solid" "black")

; Template:
; (define (draw-piece.lop lop image)
;   (Cond
;     [(empty? lop) ...)
;     [else
;       (draw-piece.lop (rest lop) (draw-piece (first lop) image)))))

; Code:
(define (draw-piece.lop lop image)
  (cond
    [(empty? lop) image]
    [else
     (draw-piece.lop (rest lop) (draw-piece (first lop) image))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Design/Text/Image Variables ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define LOGO (bitmap "img/menu.png"))

; Victory image for player one
(define P1-VICTORY (above (overlay (text "Victory - Player 1!" 40 "white")
                               (overlay
                               (rectangle 500 125 "solid" "black")
                               (rectangle 505 130 "solid" "green")))
                      (overlay (text "Press R to restart" 30 "white")
                               (overlay
                               (rectangle 500 100 "solid" "black")
                               (rectangle 505 105 "solid" "green")))))

; Victory image for player two
(define P2-VICTORY (above (overlay (text "Victory - Player 2!" 40 "white")
                               (overlay
                               (rectangle 500 125 "solid" "black")
                               (rectangle 505 130 "solid" "cyan")))
                      (overlay (text "Press R to restart" 30 "white")
                               (overlay
                               (rectangle 500 100 "solid" "black")
                               (rectangle 505 105 "solid" "cyan")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: draw-text
; I/O: AppState Image -> Image
; Interpretation: Displays the winning message at the end of the game

; Header:
; (define (draw-text st image) (square 10 "solid" "black"))

; Template:
; (define (draw-text st image)
;   (cond
;     [(string=? "victory1" (appstate-current st))
;         (place-image ... ... ... image)]
;     [(string=? "victory2" (appstate-current st))
;         (place-image ... ... ... image)]
;     [else image]))

; Code:
(define (draw-text st image)
  (cond
    [(string=? "victory1" (appstate-current st))
         (place-image P1-VICTORY
                      400
                      400
                      image)]
    [(string=? "victory2" (appstate-current st))
     (place-image P2-VICTORY
                  400
                  400
                  image)]
    [else image]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: draw-appstate
; I/O: AppState -> Image
; Interpretation: Combines all drawing functions and draws the complete chessboard with all elements

; Header:
; (draw-appstate st) (square 1 "solid" "black")

; Template:
; (define (draw-appstate st)
;  (if
;    (... (... st))
;    (...)
;    (draw-chessboard ... (empty-scene ... ...))))

; Code:
(define (draw-appstate st)
  (if (string=? "mainmenu" (appstate-current st))
      (place-image LOGO
                   400
                   400
                   (empty-scene 800 800))
      (draw-text st
                 (draw-piece.lop (appstate-lop st)
                                 (draw-select st
                                              (draw-chessboard 0
                                                               (empty-scene 800 800)))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: blockpos-x
; I/O: BoardPosition -> Positive Integer
; Interpretation: Finds the x coordinate in respect to the given column number

; Header:
; (define (blockpos-x position) 50)

; Examples:
(check-expect (blockpos-x A5) 50)
(check-expect (blockpos-x D4) 350)
(check-expect (blockpos-x H8) 750)

; Template:
; (define (blockpos-x position)
;  (... boardpos-x postion ...)

; Code:
(define (blockpos-x position)
  (+ 50 (* (- (boardpos-x position) 1) 100)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: blockpos-y
; I/O: BoardPosition -> Positive Integer
; Interpretation: Finds the y coordinate in respect to the given row number

; Header:
; (define (blockpos-y position) 50)

; Examples:
(check-expect (blockpos-y A1) 50)
(check-expect (blockpos-y D8) 750)
(check-expect (blockpos-y H8) 750)

; Template:
; (define (blockpos-y position)
;  (... boardpos-y postion ...)

(define (blockpos-y position)
  (+ 50 (* (- (boardpos-y position) 1) 100)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: find-xdist
; I/O: AppState -> Positive Integer (including 0)
; Interpretation: Finds the amount of blocks (x distance) between the selector and
; the chosen piece.

; Header:
; (define (find-xdist st) 0)

; Examples:
(check-expect (find-xdist (make-appstate LOP
                                         D6
                                         A7
                                         #t
                                         #f
                                         "player1"
                                         D7))
              0)

(check-expect (find-xdist (make-appstate LOP
                                         F6
                                         A7
                                         #f
                                         #t
                                         "player2"
                                         F7))
              5)


; Template:
; (define (find-xdist st)
;   (if (appstate-select1 st)
;     (... (... (boardpos-x (appstate-pos1 st)) (boardpos-x (appstate-go st))))
;     (... (... (boardpos-x (appstate-pos2 st)) (boardpos-x (appstate-go st))))

; Code:
(define (find-xdist st)
  (if (appstate-select1 st)
      (abs (- (boardpos-x (appstate-pos1 st)) (boardpos-x (appstate-go st))))
      (abs (- (boardpos-x (appstate-pos2 st)) (boardpos-x (appstate-go st))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: find-ydist
; I/O: Appstate -> Positive Integer (including 0)
; Interpretation: Finds the amount of blocks (y distance) between the selection and
; the chosen piece.

; Header:
; (define (find-ydist st) 0)

; Examples:
(check-expect (find-ydist (make-appstate LOP
                                         D6
                                         A7
                                         #t
                                         #f
                                         "player1"
                                         D7))
              1)

(check-expect (find-ydist (make-appstate LOP
                                         D6
                                         A4
                                         #f
                                         #t
                                         "player2"
                                         F7))
              3)

; Template:
; (define (find-ydist st)
;  (if (appstate-select1 st)
;     (... (... (boardpos-y (appstate-pos1 st)) (boardpos-y (appstate-go st))))
;     (... (... (boardpos-y (appstate-pos2 st)) (boardpos-y (appstate-go st))))

; Code:
(define (find-ydist st)
  (if (appstate-select1 st)
      (abs (- (boardpos-y (appstate-pos1 st)) (boardpos-y (appstate-go st))))
      (abs (- (boardpos-y (appstate-pos2 st)) (boardpos-y (appstate-go st))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: posn->boardpos
; I/O: Integer Integer -> BoardPosition
; Interpretation: Finds the exact position of the chessboard and converts it to a BoardPosition

; Examples:
(check-expect (posn->boardpos 400 350) D4)
(check-expect (posn->boardpos 182 621) B7)

; Template:
; (define (posn->boardpos x y)
;   (make-boardpos
;     (... (... x ...))
;     (... (... y ...))

; Code:
(define (posn->boardpos x y)
    (make-boardpos 
        (ceiling (/ x (image-width BLOCK-w)))
        (ceiling (/ y (image-height BLOCK-w)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: movePlayer
; I/O: AppState PositiveInteger PositiveInteger -> AppState
; Interpretation: Moves the position of the state to the selected block on the chessboard

(check-expect (movePlayer (make-appstate LOP
                                         B2
                                         G1
                                         #t
                                         #f
                                         "player1"
                                         B3) 1 1)
              ST2)

(check-expect (movePlayer (make-appstate LOP
                                         C4
                                         D3
                                         #f
                                         #t
                                         "player2"
                                         A1) 3 4)
              (make-appstate LOP
                             C4
                             A1
                             #f
                             #t
                             "player2"
                             A1))

; Template:
; (define (movePlayer st x y)
;    (if (string=? (appstate-current st) ...)
;        (struct-copy appstate st [pos1 (... x y ...)])
;        (struct-copy appstate st [pos2 (... x y ...)])))

; Code:
(define (movePlayer st x y)
    (if (string=? "player1" (appstate-current st))
        (struct-copy appstate st [pos1 (posn->boardpos x y)])
        (struct-copy appstate st [pos2 (posn->boardpos x y)])))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Data Types:
; Maybe<Piece> is one of the following:
; - Piece : if a piece on a certain chessboard location exists
; - #f    : if a piece on a certain chessboard location does NOT exist

; Function name: find-piece
; I/O: List<Piece> Posn -> Maybe<Piece>
; Interpretation: Finds and returns the piece at a given chessboard location, or returns
; #f if no piece can be found on that location

; Header:
; (define (find-piece lop position) PAWN-1w)

; Examples:
(check-expect (find-piece LOP G1) HORSE-2b)
(check-expect (find-piece LOP H2) PAWN-8b)
(check-expect (find-piece LOP (make-boardpos 10 10)) #f)

; Template:
; (define (find-piece lop position)
;  (cond
;   [(empty? lop) ...]
;   [(and (... (boardpos-x (... (first lop))) (boardpos-x position))
;         (... (boardpos-y (... (first lop))) (boardpos-y position)))
;     (first lop)]
;   [else
;    (find-piece (rest lop) position)]))

; Code:
(define (find-piece lop position)
  (cond
    [(empty? lop) #f]
    [(and (= (boardpos-x (piece-position (first lop))) (boardpos-x position))
          (= (boardpos-y (piece-position (first lop))) (boardpos-y position)))
     (first lop)]
    [else
     (find-piece (rest lop) position)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: can-release?
; I/O: Appstate -> Boolean
; Interpretation: Determines whether a certain piece can be placed on a boardposition

; Header:
; (define (can-release? st) #t)

; Examples:
(check-expect (can-release? (make-appstate LOP
                                           E6
                                           D1
                                           #f
                                           #f
                                           "player1"
                                           A8))
              #true)

; Template:
; (define (can-release? st)
;   [local ((define find-piece.pos1 (find-piece (appstate-lop st) (appstate-pos1 st)))
;           (define find-piece.go (find-piece (appstate-lop st) (appstate-go st)))
;           (define find-piece.pos2 (find-piece (appstate-lop st) (appstate-pos2 st)))
;           (define x (find-xdist st))
;           (define y (find-ydist st)))
;     (if (string=? ... (appstate-current st))
;       (if (... find-piece.pos1)
;          (if (string=? ... (piece-type find-piece.pos1))
;              (if (... find-piece.pos1 find-piece.go) ... ...)
;                  (cond
;                     [(string=? ... (piece-type find-piece.go))
;                        (if (... (... x ... y ...) ...)
;                     ......................................... ; checks for all other possible piece types for
;                                                                 player1 and then for player2 (repeating code)
;       (if (... find-piece.pos2)
;          .................................................... ; same as above
;                   

; Code:
(define (can-release? st)
  [local ((define find-piece.pos1 (find-piece (appstate-lop st)
                                              (appstate-pos1 st)))
          (define find-piece.go (find-piece (appstate-lop st)
                                                        (appstate-go st)))
          (define find-piece.pos2 (find-piece (appstate-lop st)
                                              (appstate-pos2 st)))
          (define x (find-xdist st))
          (define y (find-ydist st)))
    (if (string=? "player1" (appstate-current st))
        (if (piece? find-piece.pos1)
            (if (string=? "white" (piece-side find-piece.pos1))
                (if (eq? find-piece.pos1
                         find-piece.go)
                    #t
                    #f)
                (cond
                  [(string=? "horse" (piece-type find-piece.go))
                   (if (or (and (= x 1) (= y 2))
                           (and (= x 2) (= y 1)))
                       #t
                       #f)] ; Can release horse only when it moves 1 left or right and then 2 up or down,
                            ; or when moves 2 left or right and then 1 up or down
                  [(string=? "bishop" (piece-type find-piece.go))
                   (if (= x y)
                       #t
                       #f)] ; Can release bishop only when the move is diagonal to its current position
                  [(string=? "queen" (piece-type find-piece.go))
                   (if (or (= x y)
                           (= x 0)
                           (= y 0))
                       #t
                       #f)] ; Can release queen on any vertical, horizontal or diagonal position
                  [(string=? "pawn" (piece-type find-piece.go))
                   (if (= x y 1)
                       #t
                       #f)] ; Can release pawn one move up
                  [else #t]))
            (cond ;
              [(string=? "horse" (piece-type find-piece.go))
                   (if (or (and (= x 1) (= y 2))
                           (and (= x 2) (= y 1)))
                       #t
                       #f)]
              [(string=? "bishop" (piece-type find-piece.go))
                   (if (= x y)
                       #t
                       #f)]
              [(string=? "queen" (piece-type find-piece.go))
                   (if (or (= x y)
                           (= x 0)
                           (= y 0))
                       #t
                       #f)]
              [(string=? "pawn" (piece-type find-piece.go))
                   (if (= x 0)
                       #t
                       #f)]
                  [else #t]))
        (if (piece? find-piece.pos2)
            (if (string=? "black" (piece-side find-piece.pos2))
                (if (eq? find-piece.pos2
                         find-piece.go)
                    #t
                    #f)
                (cond
                  [(string=? "horse" (piece-type find-piece.go))
                   (if (or (and (= x 1) (= y 2))
                           (and (= x 2) (= y 1)))
                       #t
                       #f)]
                  [(string=? "bishop" (piece-type find-piece.go))
                   (if (= x y)
                       #t
                       #f)]
                  [(string=? "queen" (piece-type find-piece.go))
                   (if (or (= x y)
                           (= x 0)
                           (= y 0))
                       #t
                       #f)]
                  [(string=? "pawn" (piece-type find-piece.go))
                   (if (= x y 1)
                       #t
                       #f)]
                  [else #t]))
            (cond
              [(string=? "horse" (piece-type find-piece.go))
                   (if (or (and (= x 1) (= y 2))
                           (and (= x 2) (= y 1)))
                       #t
                       #f)]
              [(string=? "bishop" (piece-type find-piece.go))
                   (if (= x y)
                       #t
                       #f)]
              [(string=? "queen" (piece-type find-piece.go))
                   (if (or (= x y)
                           (= x 0)
                           (= y 0))
                       #t
                       #f)]
              [(string=? "pawn" (piece-type find-piece.go))
                   (if (= x 0)
                       #t
                       #f)]
                  [else #t])))])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: inboard?
; I/O: String Posn -> Boolean
; Interpretation: Checks and returns #t if the next move will be inside one of the chessboard blocks

; Header:
; (define (inboard? move position) #t)

; Examples:
(check-expect (inboard? "up" D3) #t)
(check-expect (inboard? "down" E8) #f)
(check-expect (inboard? "left" B8) #t)
(check-expect (inboard? "right" H4) #f)

; Template:
; (define (inboard? move position)
;  (cond
;    [(string=? ... move)
;       (if (... boardpos-x position) ...)
;    [(string=? ... move)
;       (if (... boardpos-y position) ...)
        
; Code:
(define (inboard? move position)
  (cond
    [(string=? "up" move)
     (if (< 1 (boardpos-y position))
         #t
         #f)]
    [(string=? "left" move)
     (if (< 1 (boardpos-x position))
         #t
         #f)]
    [(string=? "right" move)
     (if (> 8 (boardpos-x position))
         #t
         #f)]
    [(string=? "down" move)
     (if (> 8 (boardpos-y position))
         #t
         #f)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: control-selector
; I/O: String AppState -> AppState
; Interpretation: Moves the selector by one block on the chessboard in the spcified direction

; Header:
; (define (control-selector move st) STATE)

; Examples:
(check-expect (control-selector "up" (make-appstate LOP
                                                    E6
                                                    D1
                                                    #f
                                                    #f
                                                    "player1"
                                                    A8))
              (make-appstate LOP
                             E5
                             D1
                             #f
                             #f
                             "player1"
                             A8))

(check-expect (control-selector "left" (make-appstate LOP
                                                      B2
                                                      G1
                                                      #t
                                                      #f
                                                      "player1"
                                                      B3))
              (make-appstate LOP
                             A2
                             G1
                             #t
                             #f
                             "player1"
                             B3))

; Template:
; (define (control-selector move st)
;  [local ((define x1 (boardpos-x (appstate-pos1 st)))
;          (define y1 (boardpos-y (appstate-pos1 st)))
;          (define x2 (boardpos-x (appstate-pos2 st)))
;          (define y2 (boardpos-y (appstate-pos2 st))))
;          
;  (if (string=? "player1" (appstate-current st))
;      (cond
;        [(string=? ... move)
;         (struct-copy appstate st [... (make-boardpos (... x1 ...)
;                                                      (... y1 ...))])]
;      (cond
;        [(string=? ... move)
;         (struct-copy appstate st [... (make-boardpos (... x2 ...)
;                                                      (... y2 ...))])]     

; Code:
(define (control-selector move st)
  [local ((define x1 (boardpos-x (appstate-pos1 st)))
          (define y1 (boardpos-y (appstate-pos1 st)))
          (define x2 (boardpos-x (appstate-pos2 st)))
          (define y2 (boardpos-y (appstate-pos2 st))))
          
  (if (string=? "player1" (appstate-current st))
      (cond
        [(string=? "up" move)
         (struct-copy appstate st [pos1 (make-boardpos x1
                                                       (sub1 y1))])]
        [(string=? "left" move)
         (struct-copy appstate st [pos1 (make-boardpos (sub1 x1)
                                                       y1)])]
        [(string=? "down" move)
         (struct-copy appstate st [pos1 (make-boardpos x1
                                                       (add1 y1))])]
        [(string=? "right" move)
         (struct-copy appstate st [pos1 (make-boardpos (add1 x1)
                                                       y1)])])
      (cond
        [(string=? "up" move)
         (struct-copy appstate st [pos2 (make-boardpos x2
                                                       (sub1 y2))])]
        [(string=? "left" move)
         (struct-copy appstate st [pos2 (make-boardpos (sub1 x2)
                                                       y2)])]
        [(string=? "down" move)
         (struct-copy appstate st [pos2 (make-boardpos x2
                                                       (add1 y2))])]
        [(string=? "right" move)
         (struct-copy appstate st [pos2 (make-boardpos (add1 x2)
                                                       y2)])]))])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: can-take?
; I/O: AppState -> Boolean
; Interpretation: Checks and returns #t if the current move can take a piece from the opponent.

; Header:
; (define (can-take? st) #t)

; Examples:
(check-expect (can-take? (make-appstate LOP
                                        E6
                                        A7
                                        #f
                                        #f
                                        "player2"
                                        A2))
              #t)
(check-expect (can-take? (make-appstate LOP
                                        C1
                                        B8
                                        #f
                                        #f
                                        "player1"
                                        B5))
              #t)
(check-expect (can-take? STATE) #f)

; Template:
; (define (can-take? st)
;  (cond [(string=? ... (appstate-current st))
;         (if (... (find-piece (appstate-lop st) (... st)))
;             (if (string=? ... (piece-side (find-piece (appstate-lop st)
;                                                           (... st))))
;                 ...
;                 ...)
;             ...)]
;        [else (if (... (find-piece (appstate-lop st) (... st)))
;                  (if (string=? ... (piece-side (find-piece (appstate-lop st)
;                                                                (... st))))
;                      ...
;                      ...)
;                  ...)]))

; Code:
(define (can-take? st)
  (cond [(string=? "player1" (appstate-current st))
         (if (piece? (find-piece (appstate-lop st) (appstate-pos1 st)))
             (if (string=? "white" (piece-side (find-piece (appstate-lop st)
                                                           (appstate-pos1 st))))
                 #f
                 #t)
             #f)]
        [else (if (piece? (find-piece (appstate-lop st) (appstate-pos2 st)))
                  (if (string=? "black" (piece-side (find-piece (appstate-lop st)
                                                                (appstate-pos2 st))))
                      #f
                      #t)
                  #f)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: take-piece
; I/O: AppState -> AppState
; Interpretation: Returns the AppState without the piece that was just taken by the opponent

; Header:
; (define (take-piece st) STATE)

; Examples:

; Template:
; (define (take-piece st)
;  (local ((define find.piece (piece-type (find-piece (appstate-lop st) (appstate-go st))))
;          (define remove.piece.pos1 (remove (find-piece (appstate-lop st) (appstate-pos1 st))
;                                            (remove (find-piece (appstate-lop st)
;                                                                (appstate-go st))
;                                                    (appstate-lop st))))
;          (define remove.piece.pos2 (remove (find-piece (appstate-lop st) (appstate-pos2 st))
;                                            (remove (find-piece (appstate-lop st)
;                                                                (appstate-go st))
;                                                    (appstate-lop st)))))
;  (if (string=? ... (appstate-current st))
;      (if (string=? ... (piece-type (find-piece (appstate-lop st)
;                                                  (appstate-pos1 st))))
;          (struct-copy appstate st [lop (cons (make-piece find.piece
;                                                          ...
;                                                          ...)
;                                              remove.piece.pos1)]
;                       [current ...]
;                       [select1 ...])
;          ...
;      (if (string=? ... (piece-type (find-piece (appstate-lop st) (appstate-pos2 st))))
;          (struct-copy appstate st [lop (cons (make-piece find.piece
;                                                          ...
;                                                          ...)
;                                             remove.piece.pos2)]
;                       [current ...]
;                       [select2 ...])
;          ...

; Code:
(define (take-piece st)
  (local ((define find.piece (piece-type (find-piece (appstate-lop st) (appstate-go st)))) ; finds the piece from the list in the appstate
          (define remove.piece.pos1 (remove (find-piece (appstate-lop st) (appstate-pos1 st))
                                            (remove (find-piece (appstate-lop st)
                                                                (appstate-go st))
                                                    (appstate-lop st)))) ; removes the piece from the list in the appstate if taken
          (define remove.piece.pos2 (remove (find-piece (appstate-lop st) (appstate-pos2 st))
                                            (remove (find-piece (appstate-lop st)
                                                                (appstate-go st))
                                                    (appstate-lop st))))) ; removes the piece from the list in the appstate if taken
  (if (string=? "player1" (appstate-current st))
      (if (string=? "king" (piece-type (find-piece (appstate-lop st)
                                                  (appstate-pos1 st))))
          (struct-copy appstate st [lop (cons (make-piece find.piece
                                                          (appstate-pos1 st)
                                                          "white")
                                              remove.piece.pos1)]
                       [current "victory1"]
                       [select1 #f])
          (struct-copy appstate st [lop (cons (make-piece find.piece
                                                          (appstate-pos1 st)
                                                          "white")
                                              remove.piece.pos1)]
                       [current "player2"]
                       [select1 #f]))
      (if (string=? "king" (piece-type (find-piece (appstate-lop st) (appstate-pos2 st))))
          (struct-copy appstate st [lop (cons (make-piece find.piece
                                                          (appstate-pos2 st)
                                                          "black")
                                             remove.piece.pos2)]
                       [current "victory2"]
                       [select2 #f])
          (struct-copy appstate st [lop (cons (make-piece find.piece
                                                          (appstate-pos2 st)
                                                          "black")
                                              remove.piece.pos2)]
                       [current "player1"]
                       [select2 #f])))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: handle-mouse
; I/O: AppState Number Number MouseEvent -> Appstate
; Interpretation: Handles the mouse events "button-down", "move", "drag", "button-up"

; Header:
; (define (handle-mouse st x y e) STATE)

; Examples:
(check-expect (handle-mouse (make-appstate LOP
                                         B2
                                         G1
                                         #t
                                         #f
                                         "player1"
                                         B3) 1 1 "move") ST2)

; Template:
; (define (handle-mouse st x y e)
;  (cond
;    [(= e "button-down") (... st ... x ... y ...)]
;    [(= e "move")        (... st ... x ... y ...)]
;    [(= e "drag")        (... st ... x ... y ...)]
;    [(= e "button-up")   (... st ... x ... y ...)]
;    [else                (... st ...)]))

(define (handle-mouse st x y e)
  (cond
    [(string=? e "button-down") (handle-key st " ")]
    [(string=? e "move")  (movePlayer st x y)]
    [(string=? e "drag") (movePlayer st x y)]
    [(string=? e "button-up") (handle-key st " ")]
    [else st]) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: handle-key
; I/O: AppState KeyEvent -> AppState
; Interpretation: Handles key events "r", " ", "w", "a", "s", "d", "up", "down", "left", "right"

; Header:
; (define (handle-key st e) STATE)

; Examples:
(check-expect (handle-key (make-appstate LOP
                                         A1
                                         A8
                                         #f
                                         #t
                                         "player2"
                                         A1) "up") (make-appstate LOP
                                                                  A1
                                                                  A7
                                                                  #f
                                                                  #t
                                                                  "player2"
                                                                  A1))
(check-expect (handle-key (make-appstate LOP
                                         C4
                                         G7
                                         #t
                                         #f
                                         "player1"
                                         B2) "a") (make-appstate LOP
                                                                 B4
                                                                 G7
                                                                 #t
                                                                 #f
                                                                 "player1"
                                                                 B2))

(check-expect (handle-key (make-appstate LOP
                                         F2
                                         C8
                                         #f
                                         #t
                                         "player2"
                                         A1) "right") (make-appstate LOP
                                                                     F2
                                                                     C8
                                                                     #f
                                                                     #t
                                                                     "player2"
                                                                     A1))
(check-expect (handle-key STATE-BEGIN "r") STATE)

; Template:
;(define (handle-key st e)
;  (cond
;    [(key=? e "r") ...]
;    [(string=? "player1" (appstate-current st))
;     (if (appstate-select1 st)
;         (cond [(key=? e " ")
;                (if (can-release? st)
;                    (if (can-take? st)
;                        (take-piece st)
;                        (if (... (find-xdist st) ... (find-ydist st) ...)
;                            (struct-copy appstate st
;                                         [lop (cons (make-piece ...
;                                                    (remove ...]
;                                         ...)
;               [(string=? ... (piece-type ...)
;                (cond
;                  [(key=? e "w")
;                   ...
;                  [(key=? e "a")
;                   ...
;                  [(key=? e "s")
;                   ...
;                  [(key=? e "d")
;                   ...
;                  [else st])]
;         (cond 
;           [(and (key=? e "w" !#or "a" "s" "d"#!) (inboard? ... (appstate-pos1 st)))
;            (control-selector ... st)]
;           [(key=? e " ")
;            (if (piece? ...)
;                (if (string=? "white" (piece-side ...)
;                    (struct-copy appstate st ...)
;                    st)
;                st)]
;            
;           [else st]))]
;    [(string=? "player2" (appstate-current st))
;     (if (appstate-select2 st)
;         ; Movement with piece selected
;         (cond [(key=? e " ")
;                (if (can-release? st)
;                    (if (can-take? st)
;                        (take-piece st)
;                        (if ... find-xdist st) ... (find-ydist st) ...)
;                            (struct-copy appstate st
;                                         [lop (cons (make-piece ...
;                                                    (remove ...]
;                                         ...)
;               [(string=? ... (piece-type ...)
;                (cond [(key=? e "down")
;                       ...
;                      [(key=? e "left")
;                       ...
;                      [(key=? e "up")
;                       ...
;                      [(key=? e "right")
;                       ...
;                      [else st])]
;         (cond 
;           [(and (key=? e "up" !#or "down" "left" "right") (inboard? ... (appstate-pos2 st)))
;            (control-selector ... st)]
;           [(key=? e " ")
;            (if (piece? ...)
;                (if (string=? "black" (piece-side ...)
;                    (struct-copy appstate st ...)
;                    st)
;                st)]
;           [else st]))]
;    [else st]))


(define (handle-key st e)
  (cond
    [(key=? e "r")
     STATE]
    [(string=? "player1" (appstate-current st))
     (if (appstate-select1 st)
         (cond [(key=? e " ")
                (if (can-release? st) ; If the piece can be released
                    (if (can-take? st) ; If the next move will take the opponent's piece
                        (take-piece st) ; Take that piece
                        (if (and (= (find-xdist st) 0) (= (find-ydist st) 0))
                            (struct-copy appstate st [select1 #f])
                            (struct-copy appstate st
                                         [lop (cons (make-piece (piece-type (find-piece (appstate-lop st)
                                                                                        (appstate-go st)))
                                                                (appstate-pos1 st)
                                                                "white")
                                                    (remove (find-piece
                                                             (appstate-lop st)
                                                             (appstate-go st))
                                                            (appstate-lop st)))] ; Otherwise make an appstate with the piece on the
                                                                                 ; new location and remove the old piece
                                         [current "player2"] ; Set the next player to player2
                                         [select1 #f]))) ; Remove the selector from player1
                    (struct-copy appstate st [select1 #f]))]
               [(string=? "pawn" (piece-type (find-piece (appstate-lop st) (appstate-go st)))) ; If the selected piece is pawn
                (cond
                  [(key=? e "w") ; If w is pressed
                   (if (= (boardpos-y (appstate-go st)) 7) ; If the pawn is on the starting position
                       (if (and (or (> 2 (find-ydist st)) ; Can move two blocks up or down
                                    (> (boardpos-y (appstate-pos1 st)) (boardpos-y (appstate-go st))))
                                (inboard? "up" (appstate-pos1 st))) ; If it is inside the chessboard when it moves up
                           (control-selector "up" st) ; Move the selector up
                           st)
                       (if (and (or (> 1 (find-ydist st)) ; Otherwise if the pawn is another location on the board it can move one up
                                    (> (boardpos-y (appstate-pos1 st)) (boardpos-y (appstate-go st))))
                                (inboard? "up" (appstate-pos1 st))) ; If it is inside the chessboard when it moves up
                           (control-selector "up" st) ; Move the selector up
                           st))]
                  [(key=? e "a") ; Same steps from above apply when the pawn needs to be moved down, left or right
                   (if (and (or (> 1 (find-xdist st))
                                (> (boardpos-x (appstate-pos1 st)) (boardpos-x (appstate-go st))))
                       (inboard? "left" (appstate-pos1 st)))
                   (control-selector "left" st)
                   st)]
                  [(key=? e "s")
                       (if (and (< (boardpos-y (appstate-pos1 st)) (boardpos-y (appstate-go st)))
                                (inboard? "down" (appstate-pos1 st)))
                           (control-selector "down" st)
                           st)]
                  [(key=? e "d")
                       (if (and (or (> 1 (find-xdist st))
                                    (< (boardpos-x (appstate-pos1 st)) (boardpos-x (appstate-go st))))
                                (inboard? "right" (appstate-pos1 st)))
                           (control-selector "right" st)
                           st)]
                      [else st])]
              [(string=? "king" (piece-type (find-piece (appstate-lop st) (appstate-go st))))
                (cond
                  [(key=? e "w")
                       (if (and (or (> 1 (find-ydist st)) ; The king can move one up, down, left or right
                                    (> (boardpos-y (appstate-pos1 st)) (boardpos-y (appstate-go st))))
                                (inboard? "up" (appstate-pos1 st)))
                           (control-selector "up" st)
                           st)]
                  [(key=? e "a")
                   (if (and (or (> 1 (find-xdist st))
                            (> (boardpos-x (appstate-pos1 st)) (boardpos-x (appstate-go st))))
                       (inboard? "left" (appstate-pos1 st)))
                   (control-selector "left" st)
                   st)]
                  [(key=? e "s")
                       (if (and (or (> 1 (find-ydist st))
                                    (< (boardpos-y (appstate-pos1 st)) (boardpos-y (appstate-go st))))
                                (inboard? "down" (appstate-pos1 st)))
                           (control-selector "down" st)
                           st)]
                  [(key=? e "d")
                       (if (and (or (> 1 (find-xdist st))
                                    (< (boardpos-x (appstate-pos1 st)) (boardpos-x (appstate-go st))))
                                (inboard? "right" (appstate-pos1 st)))
                           (control-selector "right" st)
                           st)]
                  [else st])]
              [(string=? "rook" (piece-type (find-piece (appstate-lop st) (appstate-go st))))
                (cond
                  [(key=? e "w")
                       (if (and (= (find-xdist st) 0) (inboard? "up" (appstate-pos1 st))) ; it can move x amount of blocks up
                                                                                          ; and down vertically
                           (control-selector "up" st)
                           st)]
                  [(key=? e "a")
                       (if (and (= (find-ydist st) 0) (inboard? "left" (appstate-pos1 st))) ; It can move x amount of blocks left
                                                                                            ; and right horizontally
                           (control-selector "left" st)
                           st)]
                  [(key=? e "s")
                       (if (and (= (find-xdist st) 0) (inboard? "down" (appstate-pos1 st)))
                           (control-selector "down" st)
                           st)]
                  [(key=? e "d")
                       (if (and (= (find-ydist st) 0) (inboard? "right" (appstate-pos1 st)))
                           (control-selector "right" st)
                           st)]
                  [else st])]
              [(string=? "horse" (piece-type (find-piece (appstate-lop st) (appstate-go st))))
                (cond [(key=? e "w")
                       (if (= (find-xdist st) 2)
                           (if (and (or (> 1 (find-ydist st))
                                        (> (boardpos-y (appstate-pos1 st)) (boardpos-y (appstate-go st)))) ; Captures each state of all
                                                                                                           ; possible horse movements 
                                    (inboard? "up" (appstate-pos1 st)))
                               (control-selector "up" st)
                               st)
                           (if (and (or (> 2 (find-ydist st))
                                        (> (boardpos-y (appstate-pos1 st)) (boardpos-y (appstate-go st))))
                                    (inboard? "up" (appstate-pos1 st)))
                               (control-selector "up" st)
                               st))]
                      [(key=? e "a")
                       (if (= (find-ydist st) 2)
                           (if (and (or (> 1 (find-xdist st))
                                        (> (boardpos-x (appstate-pos1 st)) (boardpos-x (appstate-go st))))
                                    (inboard? "left" (appstate-pos1 st)))
                               (control-selector "left" st)
                               st)
                           (if (and (or (> 2 (find-xdist st))
                                        (> (boardpos-x (appstate-pos1 st)) (boardpos-x (appstate-go st))))
                                    (inboard? "left" (appstate-pos1 st)))
                               (control-selector "left" st)
                               st))]
                      [(key=? e "s")
                       (if (= (find-xdist st) 2)
                           (if (and (or (> 1 (find-ydist st))
                                        (< (boardpos-y (appstate-pos1 st)) (boardpos-y (appstate-go st))))
                                    (inboard? "down" (appstate-pos1 st)))
                               (control-selector "down" st)
                               st)
                           (if (and (or (> 2 (find-ydist st))
                                        (< (boardpos-y (appstate-pos1 st)) (boardpos-y (appstate-go st))))
                                    (inboard? "down" (appstate-pos1 st)))
                               (control-selector "down" st)
                               st))]
                      [(key=? e "d")
                       (if (= (find-ydist st) 2)
                           (if (and (or (> 1 (find-xdist st))
                                        (< (boardpos-x (appstate-pos1 st)) (boardpos-x (appstate-go st))))
                                    (inboard? "right" (appstate-pos1 st)))
                               (control-selector "right" st)
                               st)
                           (if (and (or (> 2 (find-xdist st))
                                        (< (boardpos-x (appstate-pos1 st)) (boardpos-x (appstate-go st))))
                                    (inboard? "right" (appstate-pos1 st)))
                               (control-selector "right" st)
                               st))]
                      [else st])]
              [(string=? "bishop" (piece-type (find-piece (appstate-lop st) (appstate-go st))))
                (cond [(key=? e "w")
                       (if (inboard? "up" (appstate-pos1 st))
                           (control-selector "up" st)
                           st)]
                      [(key=? e "a")
                       (if (inboard? "left" (appstate-pos1 st))
                           (control-selector "left" st)
                           st)]
                      [(key=? e "s")
                       (if (inboard? "down" (appstate-pos1 st))
                           (control-selector "down" st)
                           st)]
                      [(key=? e "d")
                       (if (inboard? "right" (appstate-pos1 st))
                           (control-selector "right" st)
                           st)]
                      [else st])]
              [(string=? "queen" (piece-type (find-piece (appstate-lop st) (appstate-go st))))
                (cond [(key=? e "w")
                       (if (inboard? "up" (appstate-pos1 st))
                           (control-selector "up" st)
                           st)]
                      [(key=? e "a")
                       (if (inboard? "left" (appstate-pos1 st))
                           (control-selector "left" st)
                           st)]
                      [(key=? e "s")
                       (if (inboard? "down" (appstate-pos1 st))
                           (control-selector "down" st)
                           st)]
                      [(key=? e "d")
                       (if (inboard? "right" (appstate-pos1 st))
                           (control-selector "right" st)
                           st)]
                      [else st])]
               [else st])
         (cond ; Free movement of the piece
           [(and (key=? e "w") (inboard? "up" (appstate-pos1 st)))
            (control-selector "up" st)]
            
           [(and (key=? e "s") (inboard? "down" (appstate-pos1 st)))
            (control-selector "down" st)]
            
           [(and (key=? e "a") (inboard? "left" (appstate-pos1 st)))
            (control-selector "left" st)]

           [(and (key=? e "d") (inboard? "right" (appstate-pos1 st)))
            (control-selector "right" st)]
           [(key=? e " ") ; If space is clicked it selects the piece
            (if (piece? (find-piece (appstate-lop st) (appstate-pos1 st)))
                (if (string=? "white" (piece-side (find-piece (appstate-lop st)
                                                             (appstate-pos1 st))))
                    ; If the color is right, remember the piece the player picked up
                    (struct-copy appstate st
                                 [select1 #true]
                                 [go (appstate-pos1 st)])
                    st)
                st)]
            
           [else st]))]
    [(string=? "player2" (appstate-current st)) ; Same rules apply for player2, repetition of code due to the inverse of
                                                ; x and y axis of the piece movements
     (if (appstate-select2 st)
         (cond [(key=? e " ")
                (if (can-release? st)
                    (if (can-take? st)
                        (take-piece st)
                        (if (and (= 0 (find-xdist st)) (= 0 (find-ydist st)))
                            (struct-copy appstate st [select2 #f])
                            (struct-copy appstate st
                                         [lop (cons (make-piece (piece-type (find-piece (appstate-lop st)
                                                                                        (appstate-go st)))
                                                                   (appstate-pos2 st)
                                                                   "black")
                                                       (remove (find-piece
                                                                (appstate-lop st)
                                                                (appstate-go st))
                                                               (appstate-lop st)))]
                                         [current "player1"]
                                         [select2 #f])))
                    (struct-copy appstate st [select2 #f]))]
               ; Move the piece around
               [(string=? "pawn" (piece-type (find-piece (appstate-lop st) (appstate-go st))))
                (cond [(key=? e "down")
                       (if (= 2 (boardpos-y (appstate-go st)))
                           (if (and (or (> 2 (find-ydist st))
                                        (< (boardpos-y (appstate-pos2 st)) (boardpos-y (appstate-go st))))
                                    (inboard? "down" (appstate-pos2 st)))
                               (control-selector "down" st)
                               st)
                           (if (and (or (> 1 (find-ydist st))
                                        (< (boardpos-y (appstate-pos2 st)) (boardpos-y (appstate-go st))))
                                    (inboard? "down" (appstate-pos2 st)))
                               (control-selector "down" st)
                               st))]
                      [(key=? e "left")
                       (if (and (or (> 1 (find-xdist st))
                                    (> (boardpos-x (appstate-pos2 st)) (boardpos-x (appstate-go st))))
                                (inboard? "left" (appstate-pos2 st)))
                           (control-selector "left" st)
                           st)]
                      [(key=? e "up")
                       (if (and (> (boardpos-y (appstate-pos2 st)) (boardpos-y (appstate-go st)))
                                (inboard? "up" (appstate-pos2 st)))
                           (control-selector "up" st)
                           st)]
                      [(key=? e "right")
                       (if (and (or (> 1 (find-xdist st))
                                    (< (boardpos-x (appstate-pos2 st)) (boardpos-x (appstate-go st))))
                                (inboard? "right" (appstate-pos2 st)))
                           (control-selector "right" st)
                           st)]
                      [else st])]
               [(string=? "king" (piece-type (find-piece (appstate-lop st) (appstate-go st))))
                (cond [(key=? e "up")
                       (if (and (or (> 1 (find-ydist st))
                                    (> (boardpos-y (appstate-pos2 st)) (boardpos-y (appstate-go st))))
                                (inboard? "up" (appstate-pos2 st)))
                           (control-selector "up" st)
                           st)]
                      [(key=? e "left")
                       (if (and (or (> 1 (find-xdist st))
                                    (> (boardpos-x (appstate-pos2 st)) (boardpos-x (appstate-go st))))
                                (inboard? "left" (appstate-pos2 st)))
                           (control-selector "left" st)
                           st)]
                      [(key=? e "down")
                       (if (and (or (> 1 (find-ydist st))
                                    (< (boardpos-y (appstate-pos2 st)) (boardpos-y (appstate-go st))))
                                (inboard? "down" (appstate-pos2 st)))
                           (control-selector "down" st)
                           st)]
                      [(key=? e "right")
                       (if (and (or (> 1 (find-xdist st))
                                    (< (boardpos-x (appstate-pos2 st)) (boardpos-x (appstate-go st))))
                                (inboard? "right" (appstate-pos2 st)))
                           (control-selector "right" st)
                           st)]
                      [else st])]
               [(string=? "rook" (piece-type (find-piece (appstate-lop st) (appstate-go st))))
                (cond [(key=? e "up")
                       (if (and (= 0 (find-xdist st)) (inboard? "up" (appstate-pos2 st)))
                           (control-selector "up" st)
                           st)]
                      [(key=? e "left")
                       (if (and (= 0 (find-ydist st)) (inboard? "left" (appstate-pos2 st)))
                           (control-selector "left" st)
                           st)]
                      [(key=? e "down")
                       (if (and (= 0 (find-xdist st)) (inboard? "down" (appstate-pos2 st)))
                           (control-selector "down" st)
                           st)]
                      [(key=? e "right")
                       (if (and (= 0 (find-ydist st)) (inboard? "right" (appstate-pos2 st)))
                           (control-selector "right" st)
                           st)]
                      [else st])]
               [(string=? "horse" (piece-type (find-piece (appstate-lop st) (appstate-go st))))
                (cond [(key=? e "up")
                       (if (= 2 (find-xdist st))
                           (if (and (or (> 1 (find-ydist st))
                                        (> (boardpos-y (appstate-pos2 st)) (boardpos-y (appstate-go st))))
                                    (inboard? "up" (appstate-pos2 st)))
                               (control-selector "up" st)
                               st)
                           (if (and (or (> 2 (find-ydist st))
                                        (> (boardpos-y (appstate-pos2 st)) (boardpos-y (appstate-go st))))
                                    (inboard? "up" (appstate-pos2 st)))
                               (control-selector "up" st)
                               st))]
                      [(key=? e "left")
                       (if (= 2 (find-ydist st))
                           (if (and (or (> 1 (find-xdist st))
                                        (> (boardpos-x (appstate-pos2 st)) (boardpos-x (appstate-go st))))
                                    (inboard? "left" (appstate-pos2 st)))
                               (control-selector "left" st)
                               st)
                           (if (and (or (> 2 (find-xdist st))
                                        (> (boardpos-x (appstate-pos2 st)) (boardpos-x (appstate-go st))))
                                    (inboard? "left" (appstate-pos2 st)))
                               (control-selector "left" st)
                               st))]
                      [(key=? e "down")
                       (if (= 2 (find-xdist st))
                           (if (and (or (> 1 (find-ydist st))
                                        (< (boardpos-y (appstate-pos2 st)) (boardpos-y (appstate-go st))))
                                    (inboard? "down" (appstate-pos2 st)))
                               (control-selector "down" st)
                               st)
                           (if (and (or (> 2 (find-ydist st))
                                        (< (boardpos-y (appstate-pos2 st)) (boardpos-y (appstate-go st))))
                                    (inboard? "down" (appstate-pos2 st)))
                               (control-selector "down" st)
                               st))]
                      [(key=? e "right")
                       (if (= 2 (find-ydist st))
                           (if (and (or (> 1 (find-xdist st))
                                        (< (boardpos-x (appstate-pos2 st)) (boardpos-x (appstate-go st))))
                                    (inboard? "right" (appstate-pos2 st)))
                               (control-selector "right" st)
                               st)
                           (if (and (or (> 2 (find-xdist st))
                                        (< (boardpos-x (appstate-pos2 st)) (boardpos-x (appstate-go st))))
                                    (inboard? "right" (appstate-pos2 st)))
                               (control-selector "right" st)
                               st))]
                      [else st])]
               [(string=? "bishop" (piece-type (find-piece (appstate-lop st) (appstate-go st))))
                (cond [(key=? e "up")
                       (if (inboard? "up" (appstate-pos2 st))
                           (control-selector "up" st)
                           st)]
                      [(key=? e "left")
                       (if (inboard? "left" (appstate-pos2 st))
                           (control-selector "left" st)
                           st)]
                      [(key=? e "down")
                       (if (inboard? "down" (appstate-pos2 st))
                           (control-selector "down" st)
                           st)]
                      [(key=? e "right")
                       (if (inboard? "right" (appstate-pos2 st))
                           (control-selector "right" st)
                           st)]
                      [else st])]
               [(string=? "queen" (piece-type (find-piece (appstate-lop st) (appstate-go st))))
                (cond [(key=? e "up")
                       (if (inboard? "up" (appstate-pos2 st))
                           (control-selector "up" st)
                           st)]
                      [(key=? e "left")
                       (if (inboard? "left" (appstate-pos2 st))
                           (control-selector "left" st)
                           st)]
                      [(key=? e "down")
                       (if (inboard? "down" (appstate-pos2 st))
                           (control-selector "down" st)
                           st)]
                      [(key=? e "right")
                       (if (inboard? "right" (appstate-pos2 st))
                           (control-selector "right" st)
                           st)]
                      [else st])]
               [else st])
         (cond 
           [(and (key=? e "up") (inboard? "up" (appstate-pos2 st)))
            (control-selector "up" st)]
            
           [(and (key=? e "down") (inboard? "down" (appstate-pos2 st)))
            (control-selector "down" st)]
            
           [(and (key=? e "left") (inboard? "left" (appstate-pos2 st)))
            (control-selector "left" st)]

           [(and (key=? e "right") (inboard? "right" (appstate-pos2 st)))
            (control-selector "right" st)]
           [(key=? e " ")
            (if (piece? (find-piece (appstate-lop st) (appstate-pos2 st)))
                (if (string=? "black" (piece-side (find-piece (appstate-lop st)
                                                             (appstate-pos2 st))))
                    (struct-copy appstate st
                                 [select2 #true]
                                 [go (appstate-pos2 st)])
                    st)
                st)]
            
           [else st]))]
    [else st]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function name: chess
; I/O: AppState -> Appstate
; Interpretation: Starts and manages the chess game using the big-bang function

; Header:
; (define (chess st) STATE)

; Template:
; (define (chess st)
;   (big-bang ...
;    [name ...]
;    [to-draw ...]
;    [on-key ...]
;    [on-mouse ...]))

(define (chess st)
  (big-bang STATE-BEGIN
    [name "Chess"]
    [to-draw draw-appstate]
    [on-key handle-key]
    [on-mouse handle-mouse]))

(chess 0) ; Starts the chess game automatically

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; End of code
; Total lines: 1785
; Date: 11 December 2020








































































































        