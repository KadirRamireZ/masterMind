# Clase q representa al jugador, con métodos para hacer una adivinanza y crear un código secreto.
class Player

  def self.make_guess
    # Solicitar al jugador una adivinanza de 4 colores y devolverla como un arreglo de colores.
    print "Bienvenido a Mastemind"

    puts "Introduce tu adivinanza de 4 letra (R, V, B, A):"

    gets.chomp.split(',').map(&:strip)

  end

  def self.create_secret_code
    # Solicitar al jugador que cree un código secreto de 4 colores y devolverlo como un arreglo de colores.
    p "Bienvenido a Mastemind, pondremos a prueba tu capacidad mental"

    puts "Crea tu código secreto de 4 letras (R, V, B, A):"

    gets.chomp.split(',').map(&:strip)

  end
end


# Clase base para los fabricantes de código (humanos o computadora).
class CodeMaker

  COLORS = ["R", "V", "B", "A"]

  def initialize(secret_code = nil)
    # Inicializar un fabricante de código con un código secreto generado aleatoriamente, o el proporcionado si se suministra.

    @secret_code = secret_code || generate_secret_code

  end

  def generate_secret_code
    # Generar un código secreto aleatorio de 4 colores.

    Array.new(4) { COLORS.sample }

  end

  def secret_code
    # Obtener el código secreto.

    @secret_code

  end
end

# Clase para el fabricante de código por computadora, hereda de CodeMaker.
class ComputerCodeMaker < CodeMaker

  def initialize
    # Inicializar un fabricante de código por computadora con un código secreto generado aleatoriamente.

    super(generate_secret_code)

  end
end

class Board

  def initialize
    # Inicializar el tablero con un arreglo vacío para almacenar las adivinanzas y resultados.

    @attempts = []

  end

  def add_attempt(guess, result)
    # Agregar una adivinanza y su resultado al tablero.

    @attempts << { guess: guess, result: result }

  end

  def display_board
#     # Mostrar el historial de adivinanzas en el tablero.

    puts "Historial de Adivinanzas:"

    @attempts.length.times do |index|

      
      attempt = @attempts[index]

     
      guess_str = attempt[:guess].join(', ')

      result_str = "Exactos: #{attempt[:result][0]}, Colores: #{attempt[:result][1]}"

      puts "Intento #{index}: #{guess_str} - #{result_str}"
    end
  end
end

# Clase principal que representa el juego Mastermind con lógica de juego.
class MastermindGame

  MAX_ATTEMPTS = 12

  MAX_COMPUTER_ATTEMPTS = 12

  def initialize
    # Inicializar el juego, preguntar al jugador si quiere ser el creador o el adivinador, y configurar el juego en consecuencia.

    puts "Bienvenido a Mastermind. ¿Quieres ser el creador (maker) o el adivinador (breaker)?"
    role = gets.chomp.downcase.to_sym
    @player_secret_code = ""
    @code_maker = nil
    @board = Board.new

    case role
    when :maker
      @player_secret_code = Player.create_secret_code
 
      @code_maker = CodeMaker.new(@player_secret_code)
     
  
      computer_play
    when :breaker
      @code_maker = ComputerCodeMaker.new
    else
      puts "Rol no válido. Saliendo del juego."
      exit
    end
  end

  def play
    # Comenzar el juego, permitir que el jugador realice adivinanzas y verificar si ha ganado o agotado los intentos.

    puts "Comienza el juego."

    MAX_ATTEMPTS.times do |attempt_number|
      guess = Player.make_guess
      result = check_guess(guess)

      @board.add_attempt(guess, result)
      @board.display_board

      if result == [4, 0]
        puts "¡Felicidades! Has adivinado el código secreto."
        return
      end
    end

    puts "Se te han agotado los intentos. El código secreto era: " + @code_maker.secret_code.join(', ')
  end

  def computer_play
    # Permitir que la computadora adivine el código secreto.    

    puts "La computadora comenzará a adivinar."

    MAX_COMPUTER_ATTEMPTS.times do 
      computer_guess = generate_computer_guess
      result = check_guess(computer_guess)
      
      @board.add_attempt(computer_guess, result)
      @board.display_board

      if result == [4, 0]
        puts "¡La computadora ha adivinado el código secreto!"
        return
      end
    end

    puts "La computadora ha agotado sus 12 intentos. El código secreto era: " + @player_secret_code.join(',')  
  end

  def check_guess(guess)
    # Verificar una adivinanza y calcular los resultados (exactos y colores).

    secret_code = @code_maker.secret_code
    exact_matches = 0
    color_matches = 0

    guess.each_with_index do |color, index|
      if color == secret_code[index]
        exact_matches += 1
      elsif secret_code.include?(color)
        color_matches += 1
      end
    end

    [exact_matches, color_matches]
  end

  def generate_computer_guess
    # Generar una adivinanza aleatoria por parte de la computadora.

    ComputerCodeMaker.new.generate_secret_code

  end
end

# Crear una instancia del juego y comenzar a jugar.
game = MastermindGame.new
game.play