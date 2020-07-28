import numpy as np


def game_core_DH(number):
    '''Функция принимает загаданное число в диапазоне от 1 до 100

    и возвращает число попыток

    '''

    count = 1
    left_num = 1  # левая граница диапазона включительно
    right_num = 100  # правая граница диапазона включительно
    predict = (left_num+right_num)//2  # предполагаемое число

    while number != predict:
        count += 1
        predict = (left_num+right_num)//2
        if number > predict:
            left_num = predict + 1
        else:
            right_num = predict

    return(count)


def score_game(game_core):
    '''Проверяем все возможные числа из диапазона от 1 до 100,

    чтобы узнать, как быстро игра угадывает число

    '''

    count_ls = []

    for number in range(1, 101):
        count_ls.append(game_core(number))
    score = int(np.mean(count_ls))
    print(f"Ваш алгоритм угадывает число в среднем за {score} попыток")

    return(score)


score_game(game_core_DH)  # запускаем

