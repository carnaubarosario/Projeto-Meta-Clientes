-- Passo 1: Criar Tabelas de Dimensão
CREATE TABLE dim_rota (
    rota_id SERIAL PRIMARY KEY,
    rota VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE dim_cliente (
    cliente_id SERIAL PRIMARY KEY,
    codigo VARCHAR(255) NOT NULL,
    status VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255) NOT NULL,
    razao_social VARCHAR(255) NOT NULL,
    segmento VARCHAR(255) NOT NULL
);

CREATE TABLE dim_funcionario (
    funcionario_id SERIAL PRIMARY KEY,
    funcionario VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE dim_localidade (
    localidade_id SERIAL PRIMARY KEY,
    bairro VARCHAR(255) NOT NULL,
    municipio VARCHAR(255) NOT NULL,
    estado VARCHAR(255) NOT NULL
);

CREATE TABLE dim_tempo (
    tempo_id SERIAL PRIMARY KEY,
    mes VARCHAR(3) NOT NULL, -- Nome do mês
    ano INT NOT NULL
);

-- Passo 2: Inserir Dados na Dimensão Tempo
INSERT INTO dim_tempo (mes, ano) VALUES
    ('dez', 2023),
    ('jan', 2024),
    ('fev', 2024),
    ('mar', 2024),
    ('abr', 2024),
    ('mai', 2024);

-- Passo 3: Criar Tabela Fato
CREATE TABLE fato_faturamento (
    faturamento_id SERIAL PRIMARY KEY,
    rota_id INT,
    cliente_id INT,
    funcionario_id INT,
    localidade_id INT,
    tempo_id INT,
    fat_mai DECIMAL(15, 2) NOT NULL,
    fat_abr DECIMAL(15, 2) NOT NULL,
    fat_mar DECIMAL(15, 2) NOT NULL,
    fat_fev DECIMAL(15, 2) NOT NULL,
    fat_jan DECIMAL(15, 2) NOT NULL,
    fat_dez DECIMAL(15, 2) NOT NULL
);

-- Passo 4: Adicionar Restrições de Chave Estrangeira
ALTER TABLE fato_faturamento
    ADD CONSTRAINT fk_rota FOREIGN KEY (rota_id) REFERENCES dim_rota(rota_id),
    ADD CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES dim_cliente(cliente_id),
    ADD CONSTRAINT fk_funcionario FOREIGN KEY (funcionario_id) REFERENCES dim_funcionario(funcionario_id),
    ADD CONSTRAINT fk_localidade FOREIGN KEY (localidade_id) REFERENCES dim_localidade(localidade_id),
    ADD CONSTRAINT fk_tempo FOREIGN KEY (tempo_id) REFERENCES dim_tempo(tempo_id);

-- Passo 5: Criar Índices para Melhorar o Desempenho das Consultas
CREATE INDEX idx_rota_id ON fato_faturamento (rota_id);
CREATE INDEX idx_cliente_id ON fato_faturamento (cliente_id);
CREATE INDEX idx_funcionario_id ON fato_faturamento (funcionario_id);
CREATE INDEX idx_localidade_id ON fato_faturamento (localidade_id);
CREATE INDEX idx_tempo_id ON fato_faturamento (tempo_id);








import pandas as pd

# Carregar a base de dados (substitua 'caminho/do/arquivo.csv' pelo seu caminho)
df = pd.read_excel('/content/Qlik Sense - COMPRADORES (SEMESTRE) - 10 de junho de 2024.xlsx', skiprows = 2)

#Removendo linhas duplicadas
df.drop_duplicates(subset=['CÓDIGO'], inplace=True)

# Removendo a coluna 'coluna_a_remover'
df.drop(columns=['Unnamed: 10'], inplace=True)
df.drop(columns=['jun'], inplace=True)

# Renomeando colunas do dataframe
df = df.rename(columns={'FUINCIONÁRIO': 'FUNCIONÁRIO'})
df = df.rename(columns={'RAZAOSOCIAL': 'RAZAO_SOCIAL'})
df = df.rename(columns={'NOMEFANTASIA': 'NOME_FANTASIA'})
df = df.rename(columns={'mai': 'fat_mai'})
df = df.rename(columns={'abr': 'fat_abr'})
df = df.rename(columns={'mar': 'fat_mar'})
df = df.rename(columns={'fev': 'fat_fev'})
df = df.rename(columns={'jan': 'fat_jan'})
df = df.rename(columns={'dez': 'fat_dez'})

# Preencher valores faltantes (se houver) com valores padrão, como 'N/A'
df.fillna('N/A', inplace=True)

# Converter colunas para tipos de dados adequados, se necessário
Exemplo: df['CÓDIGO'] = df['CÓDIGO'].astype(int)

#Substituição de valores no dataframe
df['SEGMENTO'] = df['SEGMENTO'].replace('-', 'Não Informado')
df['SEGMENTO'] = df['SEGMENTO'].replace('# NAO UTILIZAR #', 'Não Informado')
df['BAIRRO'] = df['BAIRRO'].replace('10', 'Não Informado')
df['BAIRRO'] = df['BAIRRO'].replace('********', 'Não Informado')
df['BAIRRO'] = df['BAIRRO'].replace('***', 'Não Informado')
df['BAIRRO'] = df['BAIRRO'].replace(' ', 'Não Informado')

#Substitui '-' por '0' em colunas númericas
df['fat_mai'] = df['fat_mai'].replace('-', '0')
df['fat_abr'] = df['fat_abr'].replace('-', '0')
df['fat_mar'] = df['fat_mar'].replace('-', '0')
df['fat_fev'] = df['fat_fev'].replace('-', '0')
df['fat_jan'] = df['fat_jan'].replace('-', '0')
df['fat_dez'] = df['fat_dez'].replace('-', '0')

# Salvar a base de dados limpa e corrigida (substitua 'caminho/do/novo_arquivo.csv' pelo seu caminho)
df.to_excel('/content/Compadores.xlsx', index=False)
