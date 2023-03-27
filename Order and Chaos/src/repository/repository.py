
from src.domain.board import Board
from src.domain.domain import X_move, Zero_move

class Repository():
    def __init__(self, board = Board(), x_move = X_move(), zero_move=Zero_move()):
        self.__XMoveRepository = []
        self.__ZeroMoveRepository = []
        self.__board = board
        self.__xMove = x_move
        self.__zeroMove = zero_move

    def get_board(self):
        return self.__board.get_board()

    def add_to_the_board(self, x_position, y_position, type):
        self.__board.set_item_on_board(x_position,y_position,type)
        if type == 'x':
            self.__xMove.set_move_position(x_position,y_position)
            self.__XMoveRepository.append(self.__xMove)
        else:
            self.__zeroMove.set_move_position(x_position,y_position)
            self.__ZeroMoveRepository.append(self.__zeroMove)
    def get_x_moves(self):
        return self.__XMoveRepository

    def get_zero_move(self):
        return self.__ZeroMoveRepository