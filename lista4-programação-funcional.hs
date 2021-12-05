type CadastroSUS = [Cidadao]
type CPF = Integer
type Nome = String
type Genero = Char
type Dia = Int
type Mes = Int
type Ano = Int
type Data = (Dia, Mes, Ano)
type DataNasc = Data
type Endereco = String
type Municipio = String
type Estado = String
type Telefone = String
type Email = String
type Cidadao = (CPF, Nome, Genero, DataNasc, Endereco, Municipio, Estado, Telefone, Email)
type IdadeInicial = Int
type IdadeFinal = Int
type FaixaIdade = (IdadeInicial, IdadeFinal)
type Quantidade = Int
type Vacinados = [Vacinado]
type Vacinado = (CPF, Doses)
type Doses = [Dose]
type Dose = (Vacina, Data)
type Vacina = String
type TipoDose = Int

-- Banco de dados 

cadastro :: CadastroSUS
cadastro = [(26716347665, "Paulo Souza", 'M' , (11,10,1996),"Rua A, 202", "Muribeca", "SE", "999997000", "psouza@gmail.com"),   (87717347115, "Ana Reis", 'X' , (5,4,2000), "Rua B, 304", "Aracaju", "SE", "999826004", "areis@gmail.com"),
            (11223344556, "Cesar Oliveira", 'M', (5,1,1990), "Rua X, 18", "Sao Paulo", "SP", "981817070", "ccohen@gmail.com"),  (99999888887, "Arthur Cervero", 'M', (22,4,1992), "Rua X, 19", "Sao Paulo", "SP", "989891010", "acervero@gmail.com"),
            (22233344400, "Elizabeth Webber", 'F', (3,1,1992), "Rua Y, 50", "Campinas", "SP", "999911822", "lizweb@gmail.com"), (88812121212, "Thiago Fritz", 'M', (27,10,1986), "Rua Z, 90", "Aracaju", "SE", "91111999999", "thiagof@gmail.com"),
            (12345678900, "Antônio Pontevedra", 'M', (3,10,1977), "Rua P, 51", "Sao Paulo", "SP", "9953912", "balu@gmail.com"), (88812121211, "Arnaldo Fritz", 'M', (26,10,1966), "Rua Z, 90", "Aracaju", "SE", "91111999912", "arnaldof@gmail.com"),
            (11111111111, "Rubens Naluti", 'M', (3,1,1997), "Rua O, 0", "Campinas", "SP", "991242822", "rubens@gmail.com"),     (22222222222, "Joui Jouki", 'M', (27,10,1996), "Rua Z, 91", "Sao Cristovao", "SE", "91111999933", "joui@gmail.com"),
            (33333333333, "Dante", 'M', (12,1,1993), "Rua Y, 50", "Salvador", "BA", "999123422", "dante@gmail.com"),            (44444444444, "Carina Leone", 'F', (27,10,1998), "Rua X, 90", "Salvador", "BA", "91223449999", "leone@gmail.com")]

-- Banco de dados dos vacinados.

cadastroVac :: Vacinados
cadastroVac = [
    (22233344400,[("Pfizer", (12,07,2021))]),
    (12345678900,[("Pfizer", (12,07,2021)),("Pfizer", (12,09,2021))]),
    (11223344556, [("Astrazeneca", (8,08,2021)),("Astrazeneca", (8,10,2021))]),
    (11111111111,[("CoronaVac", (12,07,2021))]),
    (22222222222,[("Pfizer", (12,07,2021))]),
    (88812121212,[("CoronaVac", (30,07,2021)), ("CoronaVac", (30,09,2021))]),
    (99999888887, [("Astrazeneca", (2,08,2021)),("Astrazeneca", (20,09,2021))]),
    (44444444444,[("Astrazeneca", (2,08,2021)),("Astrazeneca", (20,09,2021))]),
    (33333333333,[("Janssen", (2,08,2021)),("Janssen", (2,08,2021))])
    ]

passaporteVac :: Vacinados -> CadastroSUS -> IO()
passaporteVac vs cs = do cpf <- getLine
                         if (read cpf :: CPF) == 0
                         then return ()
                         else do putStrLn (formataDados (read cpf :: CPF) vs cs) 
                                 passaporteVac vs cs

pegaNome :: CPF -> CadastroSUS -> Nome
pegaNome cpfx cs
    |  map selecNome (filter checaCPF cs) /= [] = head (map selecNome (filter checaCPF cs))
    | otherwise = "CPF NÃO CADASTRADO"
    where checaCPF (cpf,nome,gen,datanasc,end,mun,est,num,email) = cpf == cpfx
          selecNome (cpf,nome,gen,datanasc,end,mun,est,num,email) = nome

pegaVac :: CPF -> Vacinados -> Vacinado
pegaVac cpf vs
    | any checaCPF vs = head (filter checaCPF vs)
    | otherwise = (cpf,[])
    where checaCPF (cpfx, vacinas) = cpfx == cpf

formataVac :: Vacinado -> String 
formataVac (nome, [(tipo1,(dia,mes,ano))]) = concat[ tipo1, ", ", show dia, ".", show mes, ".", show ano, "\n"]
formataVac (nome, [(tipo1,(dia1,mes1,ano1)),(tipo2,(dia2,mes2,ano2))])
    | tipo1 == "Janssen" = concat[show tipo1, ", ", show dia1, ".", show mes1, ".", show ano1]
    |otherwise = concat[ tipo1, ", ", show dia1, ".", show mes1, ".", show ano1, "\n", "       ",
                         tipo2, ", ", show dia2, ".", show mes2, ".", show ano2, "\n"]
formataVac (nome, []) = "CPF NÃO VACINADO"
                

formataDados :: CPF -> Vacinados -> CadastroSUS -> String
formataDados cpf vs cs = concat ["\n", "INSIRA UM CPF\n",show cpf , "\nNOME: ", pegaNome cpf cs,"\nDOSES: ", formataVac (pegaVac cpf vs)]