from src.repository.repository import Repository
class GameException(Exception):
    pass

class Validator():
    @staticmethod
    def x_and_0_validator(m):
        if m !='0' and m!='x':
            raise GameException("you have to choose between x and 0")
    @staticmethod
    def valid_position(x_position, y_position, board):
        if type(x_position) == str or type(y_position)==str:
            raise GameException("invalid move")
        if board[x_position][y_position] != '':
            raise GameException("invalid move")
    @staticmethod
    def length_validate(length):
        if length !=2:
            raise GameException("invalid move")

