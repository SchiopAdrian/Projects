
from src.domain.domain import X_move, Zero_move
from src.domain.board import Board
from src.repository.repository import Repository
from src.GameLogistics.GameLogistics import GameLogistics
from  src.UI.UI import UI

x_move = X_move()
zero_move = Zero_move()
board = Board()
repository = Repository(board,x_move,zero_move)
game = GameLogistics(repository)
ui = UI(game)

ui.startup()