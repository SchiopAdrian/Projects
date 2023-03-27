
from src.GameLogistics.GameLogistics import GameLogistics
import texttable
from src.domain.Validator import GameException, Validator
class UI():
    def __init__(self, gameLogistics = GameLogistics()):
        self.__gameLogistics = gameLogistics

    def build_a_board(self):
        table=texttable.Texttable()
        list = self.__gameLogistics.get_board()
        for line in list:
            table.add_row(line)
        return table
    def covert_to_number(self, string):
        list = string.split()
        for el in range(0,len(list)):
            if list[el] == '1':
                list[el]= 0
            elif list[el] == '2':
                list[el]= 1
            elif list[el] == '3':
                list[el]= 2
            elif list[el] == '4':
                list[el]= 3
            elif list[el] == '5':
                list[el]= 4
            elif list[el] == '6':
                list[el]= 5
        return list
    def startup(self):
        table = self.build_a_board()
        validate = Validator()
        print(table.draw())

        while True:
            try:
                self.__gameLogistics.ai()
                table = self.build_a_board()
                print("\n\n\n\nComputer turn:")
                print(table.draw())
                m = input("\n\nplayer turn, choose what you want to put: ")
                m = m.strip()
                validate.x_and_0_validator(m)
                what_move = input("choose where you want to put it: ")
                what_move = what_move.strip()
                moves = self.covert_to_number(what_move)
                validate.length_validate(len(moves))
                validate.valid_position(moves[0],moves[1], self.__gameLogistics.get_board())
                self.__gameLogistics.add_to_board(moves[0],moves[1],m)

                table =self.build_a_board()
                print(table.draw())
                print(self.__gameLogistics.stop_the_game())
                if self.__gameLogistics.stop_the_game() == "YOU LOSE" or self.__gameLogistics.stop_the_game() == "WIN":
                    break
            except GameException as ge:
                print(ge)