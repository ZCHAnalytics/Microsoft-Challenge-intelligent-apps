import random

def determine_winner(user_choice, computer_choice):
    if user_choice == computer_choice:
        return "Tie"
    elif (user_choice == "rock" and computer_choice == "scissors") or (user_choice == "scissors" and computer_choice == "paper") or (user_choice == "paper" and computer_choice == "rock"):
        return "You win"
    else:
        return "You lose"

def play_game():
    user_score = 0
    rounds = 0

    while True:
        user_choice = input("Enter your choice (rock, paper, scissors): ").lower()

        if user_choice not in ["rock", "paper", "scissors"]:
            print("Invalid choice. Please try again.")
            continue

        computer_choice = random.choice(["rock", "paper", "scissors"])
        result = determine_winner(user_choice, computer_choice)

        print(f"You chose {user_choice}. The computer chose {computer_choice}.")
        print(result)

        if result == "You win":
            user_score += 1

        rounds += 1

        play_again = input("Do you want to play again? (yes/no): ").lower()

        if play_again != "yes":
            print(f"Game over! You won {user_score} out of {rounds} rounds.")
            break

play_game()
