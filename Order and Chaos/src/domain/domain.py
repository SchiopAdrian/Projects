
class X_move():
    def __init__(self):
        self.__position = []

    def get_move_position(self):
        return self.__position

    def set_move_position(self, position_x, position_y):
        self.__position = [position_x ,position_y]

class Zero_move():
    def __init__(self):
        self.__position = []

    def get_move_position(self):
        return self.__position

    def set_move_position(self, position_x, position_y):
        self.__position = [position_x, position_y]