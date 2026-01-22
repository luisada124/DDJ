todo:

FUNDO ARRANJAR
 

Bosse final muito mais difícil. 

 ter dIALOGO do Warp no no boss 1. 

Inimigos a spawnar fora Da visão do jogador. 

meter mais vida na nave e menos inimigos a spawnar
Meter os artefactos fora do minimapa só estarão disponíveis com mapas depois de os desbloquear. 


Mapa ser obtido como recompensa. 
Estações têm de ser ou compradas a localização ou encontradas. 
 

BALANCEAMENTO:

Balancear o preço das peças dos artefactos na zona 2 com a medista. 

Zonas específicas com mais inimigos. 
vida da nava
jogo mais lento
Estações defendidas por muitos inimigos. 
Por cooldwon no dash

Dá-me a lista de todos os itens do jogo para compra na loja. Essa lista, sabendo os drops dos meteoros e e recompensas das missões e drops dos inimigos que os kits de reparações têm de ser usados muitas vezes, portanto uma beca mais para o baratinho. 



Tamanho das estações. 

BOSSES
kit reparação está sem os recursos. 

TEXTURAS:

mecanicas a adicionar:


upgrades:



colisions layer| colide com

player - 1   | 2,3,4
cometa -2    | 1,3,4
laser - 3    | 2,4
inimigo - 4  | 1,2,3,4



Lista de artefactos e gadgets:
pensar no numero de ametistas para cada
Zona 1:

vacuum: 2 

reverse_thruster: 3

Zona 2:

broca de mineracao: 1 

Vai ser obtida logo numa estação perto do spawn da zona 2 e Vai ser um tropa que lhe vai dar para desde que ele faça recolha de 4 ametistas para ele. Se ele não cumprir e não lhe as devolver, também não consegue fazer mais missões nesse gás, e esse gás vai ter missões boas. 

side_dash: 3
Maquina auxiliar: 3

auto_regen:3

PROMPS:



Temos de fazer um menu inicial para o jogo, com o botão de continuar, "Novo Jogo". Quando clicamos no novo jogo isto é, no início do jogo, aparece um diálogo do Ricky, o nosso alien, a ser raptado pelos humanos, mas ele consegue escapar depois Deixa-nos no começo do jogo agora. implmenta isso



LOCALIZACAO DE PARTES PARA GADGETS

Zone 1 Gadgets

Gadget 1: Reverse Thruster

Required parts (3 total):

Part A: sold in a market at a Zone 1 station

Part B: sold in a different market at another Zone 1 station

Part C: located at a random point in the Zone 1 world

A map item revealing this location is sold in a Zone 1 station market

Zone 2 Gadgets

Gadget 2: Side Dash

Required parts (3 total):

Part A: sold in a Zone 2 station market

Part B: sold in a different Zone 2 station market

Part C: located at a random point in Zone 2

A map revealing this part is given as a mission reward in Zone 2

Gadget 3: Auxiliary Machine

Required parts (3 total):

Part A: mission reward in Zone 2

Part B: sold in a Zone 2 station market

Part C: located at a random point in Zone 2

A map revealing this part is given as a Zone 2 mission reward

Gadget 4: Auto Regeneration

Required parts (2 total):

2 parts scattered randomly across the Zone 2 world

2 map items:

One map sold at a Zone 1 station

One map sold at a Zone 2 station






















Premissas (para ficar consistente)
Player DPS varia muito com blaster (fire rate) + laser_damage.
Objetivo: em Lv8+, um inimigo basic deve morrer em ~2–3s, sniper em 3–4s, tank em 5–7s.
Inimigos devem matar a nave em ~8–12s se o player ficar parado a levar tiro.
Boss final: fight ~90–150s em Lv8+ com janelas de DPS + telegraph.
Player
Nave (Ship)
HP (max)
Recomendado: 220 base (Lv0)
Com hull (+10 por nível): Lv6 = 280, Lv8 = 300, Lv10 = 320
Contacto com inimigo / cometa
Cometa: 8 por colisão (com i‑frames já existentes)
Inimigo (contact_damage): usar o valor do inimigo (abaixo)
Alien (EVA)
HP (max): 70 (Lv0) → 90 (Lv8+) se quiseres progressão (ou fixa 70 e mantém EVA frágil)
Dano recebido de lasers inimigos: igual ao da nave (como já tens)
Lasers do player
Dano base: 6
laser_damage: +10% por nível (mantém como tens)
blaster: usa a tua curva (redução do intervalo). Meta: em Lv8+ ter ~2× DPS do Lv0.
Inimigos (Zona 1 / outer)
“basic / sniper / tank” (tanto spawner normal como guardas de estação).

Basic
HP: 90
Laser: 6 dmg, interval 1.25s
contact_damage: 12
move_speed: 240
desired_distance: 320
Sniper
HP: 70
Laser: 10 dmg, interval 1.85s
contact_damage: 10
move_speed: 220
desired_distance: 780 (mais longe)
Nota: o perigo aqui é precisão + distância, não HP.
Tank
HP: 190
Laser: 8 dmg, interval 1.55s
contact_damage: 18
move_speed: 190
desired_distance: 360
Nota: tank “pressiona” por aguentar e empurrar, não por DPS absurdo.
Multiplicadores por zona (em vez de inventar inimigos novos)
Usa o teu difficulty_multiplier por zona para escalar HP/dano (mais ou menos assim):

Zona 1 (outer): × 1.00
Zona 2 (mid): × 1.35
Zona 3 (core): sem spawner normal (só boss + adds do boss)
Aplicação:

HP_final = HP_base × zona_mult
laser_damage_final = laser_base × (0.95 + 0.10 × zona_mult) (sobe menos que HP para não virar “bullet hell” injusto)
Evento “Horda” (Zona 2 → Zona 3)
Speaker basic (só para falas)
Igual ao basic, mas pode ter:
HP: 60 (para morrer rápido)
dano normal
Líder (o que dropa a relíquia)
Tipo visual: vermelho (já fizeste), bem maior
HP (Zona 2): 420
Laser: 14 dmg, interval 0.95s
contact_damage: 24
Meta: em Lv8+ matar em ~8–12s (é “mini‑boss”)
Boss Final (Zona 3)
Meta do boss em Lv8+: ~90–150s de luta, dependendo de skill, com 3 fases.

Boss Final (base em Lv8+)
HP total: 2400
Laser dmg:
Fase 1: 12
Fase 2: 14
Fase 3: 16
Intervalo de tiro:
F1: 1.10s
F2: 0.85s
F3: 0.70s
Dash:
Telegraph: 0.75s
Dash duration: 0.30s
Dash speed: 1400
Cooldown: 3.2s
Adds (5 por fase):
F1: 5 basics com diff ~1.4
F2: 5 basics com diff ~1.7
F3: 5 basics com diff ~2.0
Escala para upgrades acima de 8
Em vez de aumentar tudo, aumenta só HP e dano do boss suavemente:

boss_mult = 1.0 + 0.20 * clamp(avg_upgrade - 8, 0, 2)
avg_upgrade 8 → ×1.0
avg_upgrade 9 → ×1.2
avg_upgrade 10 → ×1.4
HP_boss = 2400 × boss_mult
dano_boss = dano × (0.95 + 0.30 * (boss_mult - 1.0)) (sobe menos que HP)



FAZER

