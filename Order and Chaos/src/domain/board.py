


class Board():
    def __init__(self):
        self.__board = [['']*6,['']*6,['']*6,['']*6,['']*6,['']*6]

    def get_board(self):
        return self.__board

    def set_item_on_board(self, position_x, position_y, value):
        self.__board[position_x][position_y] = value

