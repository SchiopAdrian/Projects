import random
from src.repository.repository import Repository

class GameLogistics():
    def __init__(self, repo= Repository()):
        self.__repository = repo

    def get_board(self):
        return self.__repository.get_board()

    def add_to_board(self, position_x, position_y, type):
        self.__repository.add_to_the_board(position_x,position_y,type)

    def did_I_win(self):
        """
        checks if the player won by chenking if there are 5 on a column, diagonal or row
        :return:
        """
        X_moves = self.__repository.get_x_moves()
        zero_moves = self.__repository.get_zero_move()
        list = []
        for move in X_moves:
            list.append(move.get_move_position())
        list.sort()
        for i in range(0, 6):
            s = 0
            s1 = 0

            for j in range(len(list)):
                if list[j][0] == i and s != 5:
                    s += 1
                elif s == 5:
                    return "YOU LOSE"
                if list[j][1] == i and s1 != 5:
                    s1 += 1
                elif s1 == 5:
                    return "YOU LOSE"
            for j in range(len(list)-1):
                s2 = 0
                s3 = 0
                if list[j][0]-list[j+1][0]==1 and list[j+1][1]-list[j][1]==1 and s2 !=5:
                    s2 +=1
                elif s2==5:
                    return "YOU LOSE"
                if list[j+1][0]-list[j][0]==1 and list[j][1]-list[j+1][1]==1 and s3 !=5:
                    s3 +=1
                elif s3==5:
                    return "YOU LOSE"
        return

    def stop_the_game(self):
        board = self.__repository.get_board()
        bool = True
        for line in board:
            if '' in line:
                bool = False
        if bool:
            return "YOU WON"
        did_I_win = self.did_I_win()
        if did_I_win == None:
            return "keep on playing"
        else:
            return did_I_win

    def ai(self):

        X_moves = self.__repository.get_x_moves()
        zero_moves = self.__repository.get_zero_move()
        list_x = []
        list_0 = []
        list = []
        not_in_list = False
        for move in X_moves:
            list_x.append(move.get_move_position())
            list.append(move.get_move_position())
        for move in zero_moves:
            list_0.append(move.get_move_position())
            list.append(move.get_move_position())
        if len(list_0)>len(list_x):
            rand = 0
        elif len(list_0)<len(list_x):
            rand = 1
        else:
            rand = random.randint(0,1)
        if rand == 1:
            while not_in_list == False:
                a= random.randint(0,5)
                b = random.randint(0,5)
                if [a,b] not in list:
                    not_in_list = True
                    self.__repository.add_to_the_board(a,b,'x')

        elif rand == 0:
            while not_in_list == False:
                a = random.randint(0,5)
                b = random.randint(0,5)
                if [a,b] not in list:
                    not_in_list = True
                    self.__repository.add_to_the_board(a,b,'0')





