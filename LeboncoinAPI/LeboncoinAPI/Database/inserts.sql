BEGIN;

/*============================================================================================================================================*/
/*============================================================================================================================================*/
/* INSERTIONS PREMIER NIVEAU                                                                                                                  */
/*============================================================================================================================================*/
/*============================================================================================================================================*/ 

/*==============================================================*/
/* Table : compensation (13 compensations)                      */
/*==============================================================*/

INSERT INTO compensation (nomcompensation) VALUES

('Remboursement total de la réservation'),
('Remboursement partiel de la réservation'),
('Remboursement des frais annexes'),
('Indemnisation pour dépenses supplémentaires'),
('Remboursement des objets endommagés ou volés'),
('Remboursement pour équipements ou services manquants'),
('Fourniture d’un logement alternatif équivalent ou supérieur'),
('Bons, crédits ou services gratuits'),
('Compensation pour stress ou gêne'),
('Compensation pour inconfort'),
('Compensation pour perte de temps'),
('Compensation pour annulation forcée d’activités ou vacances'),
('Compensation pour logement dangereux ou frauduleux');

/*==============================================================*/
/* Table : categorie (4 categories)                             */
/*==============================================================*/

INSERT INTO categorie (nomcategorie) VALUES

('Équipements'),
('Extérieur'),
('Services & accessibilité'),
('Hébergement');

/*==============================================================*/
/* Table : region (18 regions)                                  */
/*==============================================================*/

INSERT INTO region (nomregion) VALUES 

('Auvergne-Rhône-Alpes'), 
('Bourgogne-Franche-Comté'), 
('Bretagne'), 
('Centre-Val de Loire'), 
('Corse'), 
('Grand Est'), 
('Hauts-de-France'), 
('Île-de-France'), 
('Normandie'), 
('Nouvelle-Aquitaine'), 
('Occitanie'), 
('Pays de la Loire'), 
('Provence-Alpes-Côte d Azur'), 
('Guadeloupe'), 
('Guyane'), 
('Martinique'), 
('Mayotte'), 
('Réunion'); 

/*==============================================================*/
/* Table : typevoyageur (4 typevoyageurs)                       */
/*==============================================================*/

INSERT INTO typevoyageur (nomtypevoyageur) VALUES 

('Adulte'), 

('Enfant'), 

('Bébé'), 

('Animal de compagnie');

/*==============================================================*/
/* Table : statut_incident                                      */
/*==============================================================*/

INSERT INTO statut_incident (idstatutincident, code, libelle, ordre, estfinal) VALUES
(1, 'SIGNALE', 'Signale', 1, FALSE),
(2, 'EN_ANALYSE_SERVICE_LOCATION', 'En cours d''analyse par le service location', 2, FALSE),
(3, 'CLASSE_SANS_SUITE', 'Classe sans suite', 3, TRUE),
(4, 'EN_ATTENTE_EXPLICATION_PROPRIETAIRE', 'En attente de l''explication du proprietaire', 4, FALSE),
(5, 'EXPLICATION_PROPRIETAIRE_RECUE', 'Explication du proprietaire recue', 5, FALSE),
(6, 'REMBOURSEMENT_ACCEPTE', 'Remboursement accepte', 6, FALSE),
(7, 'REFUS_REMBOURSEMENT', 'Remboursement refuse', 7, FALSE),
(9, 'TRANSFERE_CONTENTIEUX', 'Transfere au contentieux', 8, FALSE),
(10, 'CLOTURE_SANS_REMBOURSEMENT', 'Cloture sans remboursement', 9, TRUE),
(11, 'PROCEDURE_JURIDIQUE_ENGAGEE', 'Procedure juridique engagee', 10, TRUE),
(12, 'REMBOURSEMENT_EFFECTUE', 'Remboursement effectue', 11, TRUE);

/*==============================================================*/
/* Table : permission                                           */
/*==============================================================*/

INSERT INTO permission (idpermission, nompermission) VALUES
(4, 'incident.read.all'),
(5, 'incident.take_in_charge'),
(6, 'incident.class_without_follow_up'),
(7, 'incident.request_owner_explanation'),
(9, 'incident.decide_refund'),
(10, 'incident.process_refund'),
(13, 'incident.contentieux.close'),
(14, 'incident.contentieux.legal'),
(15, 'app.view.home'),
(16, 'app.view.favorites'),
(17, 'app.view.messages'),
(18, 'app.view.my_annonces'),
(19, 'app.view.my_reservations'),
(20, 'dashboard.settings'),
(21, 'dashboard.incidents.location'),
(22, 'dashboard.incidents.comptabilite'),
(23, 'dashboard.incidents.contentieux'),
(24, 'app.view.gdpr_data');

/*==============================================================*/
/* Table : role                                                 */
/*==============================================================*/

INSERT INTO role (idrole, nomrole) VALUES
(3, 'Service_Location'),
(4, 'Service_Comptabilite'),
(5, 'Service_Contentieux');

/*==============================================================*/
/* Table : permettre                                            */
/*==============================================================*/

INSERT INTO permettre (idrole, idpermission) VALUES
(2, 15), (2, 16), (2, 17), (2, 18), (2, 19), (2, 20), (2, 24),
(3, 4), (3, 5), (3, 6), (3, 7), (3, 9),
(3, 20), (3, 21),
(4, 4), (4, 10), (4, 20), (4, 22),
(5, 4), (5, 13), (5, 14), (5, 20), (5, 23);

/*==============================================================*/
/* Table : date (nombre de dates variable)                      */
/*==============================================================*/

INSERT INTO date ("date") 

SELECT generate_series( 

    '1900-01-01'::date, 

    (CURRENT_DATE + INTERVAL '2 years')::date, 

    '1 day'::interval 

); 

/*==============================================================*/
/* Table : heure (48 heures)                                    */
/*==============================================================*/

INSERT INTO heure (heure) 

SELECT (generate_series( 

    '2025-01-01 00:00:00'::timestamp,  

    '2025-01-01 23:30:00'::timestamp,   

    '30 minutes'::interval 

))::time; 

/*============================================================================================================================================*/
/*============================================================================================================================================*/
/* INSERTIONS DEUXIEME NIVEAU                                                                                                                 */
/*============================================================================================================================================*/
/*============================================================================================================================================*/ 

/*==============================================================*/
/* Table : commodite (57 commodites)                            */
/*==============================================================*/

INSERT INTO commodite (idcategorie, nomcommodite) VALUES 

(2, 'Jardin'), 
(2, 'Terrasse'), 
(2, 'Balcon'), 
(2, 'Piscine privée'), 
(2, 'Piscine partagée'), 
(2, 'Patio'), 
(2, 'Cour'), 
(2, 'Jacuzzi extérieur'), 
(2, 'Toit-terrasse'), 
(2, 'Balconnet'), 
(2, 'Loggia'), 
(2, 'Véranda'),
(3, 'Parking'), 
(3, 'Ménage inclus'), 
(3, 'Accessible en fauteuil roulant'), 
(3, 'Avec ascenseur'), 
(3, 'Animaux acceptés'), 
(3, 'Service de conciergerie'), 
(3, 'Réception 34h/34'), 
(3, 'Petit-déjeuner inclus'), 
(3, 'Location de vélos'), 
(3, 'Navette aéroport'), 
(3, 'Livraison de courses'), 
(3, 'Service de blanchisserie'), 
(3, 'Prêt de matériel bébé'), 
(3, 'Service de garde d’enfants'), 
(3, 'Massage à domicile'),
(1, 'Wifi gratuit'), 
(1, 'Télévision'), 
(1, 'Lave-vaisselle'), 
(1, 'Cuisine équipée'), 
(1, 'Lave-linge'), 
(1, 'Sèche-linge'), 
(1, 'Chauffage'), 
(1, 'Climatisation'), 
(1, 'Draps et linge inclus'), 
(1, 'Savon et shampoing'), 
(1, 'Barbecue / grill'), 
(1, 'Planche à repasser'), 
(1, 'Chaise haute pour bébé'), 
(1, 'Fer à repasser'), 
(1, 'Sèche-cheveux'), 
(1, 'Réfrigérateur'), 
(1, 'Congélateur'), 
(1, 'Four'), 
(1, 'Micro-ondes'), 
(1, 'Cafetière'), 
(1, 'Bouilloire'), 
(1, 'Grille-pain'), 
(1, 'Ustensiles de cuisine'), 
(1, 'Vaisselle et couverts'), 
(1, 'Lit bébé'), 
(1, 'Détecteur de fumée'), 
(1, 'Bureau / espace de travail'), 
(1, 'Armoire / penderie'), 
(1, 'Serviettes fournies'), 
(1, 'Produits d’entretien');

/*==============================================================*/
/* Table : typehebergement (9 typehebergements)                 */
/*==============================================================*/

INSERT INTO typehebergement (idcategorie, nomtypehebergement) VALUES 

(4, 'Appartement'), 
(4, 'Maison'), 
(4, 'Chambre d''hôte'), 
(4, 'Gîte'), 
(4, 'Studio'), 
(4, 'Loft'), 
(4, 'Chalet'), 
(4, 'Maison d''hôtes'), 
(4, 'Bungalow'); 

/*==============================================================*/
/* Table : departement (101 departements)                       */
/*==============================================================*/

INSERT INTO departement (idregion, numerodepartement, nomdepartement) VALUES 

(1, '01', 'Ain'), 
(1, '03', 'Allier'), 
(1, '07', 'Ardèche'), 
(1, '15', 'Cantal'), 
(1, '26', 'Drôme'), 
(1, '38', 'Isère'), 
(1, '42', 'Loire'), 
(1, '43', 'Haute-Loire'), 
(1, '63', 'Puy-de-Dôme'), 
(1, '69', 'Rhône'), 
(1, '73', 'Savoie'), 
(1, '74', 'Haute-Savoie'), 
(2, '21', 'Côte-d''Or'), 
(2, '25', 'Doubs'), 
(2, '39', 'Jura'), 
(2, '58', 'Nièvre'), 
(2, '70', 'Haute-Saône'), 
(2, '71', 'Saône-et-Loire'), 
(2, '89', 'Yonne'), 
(2, '90', 'Territoire de Belfort'), 
(3, '22', 'Côtes-d''Armor'), 
(3, '29', 'Finistère'), 
(3, '35', 'Ille-et-Vilaine'), 
(3, '56', 'Morbihan'), 
(4, '18', 'Cher'), 
(4, '28', 'Eure-et-Loir'), 
(4, '36', 'Indre'), 
(4, '37', 'Indre-et-Loire'), 
(4, '41', 'Loir-et-Cher'), 
(4, '45', 'Loiret'), 
(5, '2A', 'Corse-du-Sud'), 
(5, '2B', 'Haute-Corse'), 
(6, '08', 'Ardennes'), 
(6, '10', 'Aube'), 
(6, '51', 'Marne'), 
(6, '52', 'Haute-Marne'), 
(6, '54', 'Meurthe-et-Moselle'), 
(6, '55', 'Meuse'), 
(6, '57', 'Moselle'), 
(6, '67', 'Bas-Rhin'), 
(6, '68', 'Haut-Rhin'), 
(6, '88', 'Vosges'), 
(7, '02', 'Aisne'), 
(7, '59', 'Nord'), 
(7, '60', 'Oise'), 
(7, '62', 'Pas-de-Calais'), 
(7, '80', 'Somme'), 
(8, '75', 'Paris'), 
(8, '77', 'Seine-et-Marne'), 
(8, '78', 'Yvelines'), 
(8, '91', 'Essonne'), 
(8, '92', 'Hauts-de-Seine'), 
(8, '93', 'Seine-Saint-Denis'), 
(8, '94', 'Val-de-Marne'), 
(8, '95', 'Val-d''Oise'), 
(9, '14', 'Calvados'), 
(9, '27', 'Eure'), 
(9, '50', 'Manche'), 
(9, '61', 'Orne'), 
(9, '76', 'Seine-Maritime'), 
(10, '16', 'Charente'), 
(10, '17', 'Charente-Maritime'), 
(10, '19', 'Corrèze'), 
(10, '23', 'Creuse'), 
(10, '24', 'Dordogne'), 
(10, '33', 'Gironde'), 
(10, '40', 'Landes'), 
(10, '47', 'Lot-et-Garonne'), 
(10, '64', 'Pyrénées-Atlantiques'), 
(10, '79', 'Deux-Sèvres'), 
(10, '86', 'Vienne'), 
(10, '87', 'Haute-Vienne'), 
(11, '09', 'Ariège'), 
(11, '11', 'Aude'), 
(11, '12', 'Aveyron'), 
(11, '30', 'Gard'), 
(11, '31', 'Haute-Garonne'), 
(11, '32', 'Gers'), 
(11, '34', 'Hérault'), 
(11, '46', 'Lot'), 
(11, '48', 'Lozère'), 
(11, '65', 'Hautes-Pyrénées'), 
(11, '66', 'Pyrénées-Orientales'), 
(11, '81', 'Tarn'), 
(11, '82', 'Tarn-et-Garonne'), 
(12, '44', 'Loire-Atlantique'), 
(12, '49', 'Maine-et-Loire'), 
(12, '53', 'Mayenne'), 
(12, '72', 'Sarthe'), 
(12, '85', 'Vendée'), 
(13, '04', 'Alpes-de-Haute-Provence'), 
(13, '05', 'Hautes-Alpes'), 
(13, '06', 'Alpes-Maritimes'), 
(13, '13', 'Bouches-du-Rhône'), 
(13, '83', 'Var'), 
(13, '84', 'Vaucluse'), 
(14, '971', 'Guadeloupe'), 
(15, '973', 'Guyane'), 
(16, '972', 'Martinique'), 
(17, '976', 'Mayotte'), 
(18, '974', 'La Réunion'); 

/*============================================================================================================================================*/
/*============================================================================================================================================*/
/* INSERTIONS TROISIEME NIVEAU                                                                                                                */
/*============================================================================================================================================*/
/*============================================================================================================================================*/ 

/*==============================================================*/
/* Table : ville (116 villes)                                   */
/*==============================================================*/ 

INSERT INTO ville (iddepartement, codepostal, nomville, taxedesejour) VALUES 

-- Île-de-France (Region 8) - Commence à l'ID 48
(48, '75001', 'Paris', 2.80),
(50, '78000', 'Versailles', 2.20),   
(49, '77300', 'Fontainebleau', 1.90),
(51, '91000', 'Évry', 1.70),      
(52, '92000', 'Nanterre', 2.00),    
(54, '94000', 'Créteil', 1.70),     
(55, '95000', 'Pontoise', 1.60),     

-- Auvergne-Rhône-Alpes (Region 1) - IDs 1 à 12
(10, '69001', 'Lyon', 2.30),
(12, '74000', 'Annecy', 2.10),
(12, '74400', 'Chamonix', 2.80),
(11, '73000', 'Chambéry', 1.90),
(11, '73100', 'Aix-les-Bains', 1.90),
(6, '38000', 'Grenoble', 2.00),
(9, '63000', 'Clermont-Ferrand', 1.80),
(7, '42000', 'Saint-Étienne', 1.70),
(5, '26000', 'Valence', 1.60),
(1, '01000', 'Bourg-en-Bresse', 1.50),
(2, '03000', 'Moulins', 1.40),
(3, '07000', 'Privas', 1.40),
(4, '15000', 'Aurillac', 1.60),
(8, '43000', 'Le Puy-en-Velay', 1.50),

-- Provence-Alpes-Côte d'Azur (Region 13) - IDs 91 à 96
(94, '13001', 'Marseille', 2.40),
(94, '13100', 'Aix-en-Provence', 2.10),
(94, '13200', 'Arles', 1.90),
(94, '13500', 'Martigues', 1.70),
(93, '06000', 'Nice', 2.70),
(93, '06400', 'Cannes', 2.90),
(93, '06600', 'Antibes', 2.60),
(93, '06130', 'Grasse', 1.80),
(95, '83000', 'Toulon', 2.00),
(95, '83400', 'Hyères', 1.90),
(96, '84000', 'Avignon', 2.10),
(96, '84100', 'Orange', 1.70),
(91, '04000', 'Digne-les-Bains', 1.50),
(92, '05000', 'Gap', 1.50),

-- Hauts-de-France (Region 7) - IDs 43 à 47
(44, '59000', 'Lille', 2.20),
(44, '59100', 'Roubaix', 1.70),
(44, '59140', 'Dunkerque', 1.80),
(44, '59200', 'Tourcoing', 1.70),
(46, '62000', 'Arras', 1.60),
(46, '62100', 'Calais', 1.70),
(47, '80000', 'Amiens', 1.80),
(43, '02000', 'Laon', 1.40),
(45, '60000', 'Beauvais', 1.50),

-- Occitanie (Region 11) - IDs 73 à 85
(77, '31000', 'Toulouse', 2.30),
(79, '34000', 'Montpellier', 2.20),
(76, '30000', 'Nîmes', 1.90),
(83, '66000', 'Perpignan', 1.80),
(84, '81000', 'Albi', 1.70),
(80, '46000', 'Cahors', 1.60),
(85, '82000', 'Montauban', 1.70),
(73, '09000', 'Foix', 1.40),
(78, '32000', 'Auch', 1.40),
(81, '48000', 'Mende', 1.30),
(82, '65000', 'Tarbes', 1.50),

-- Pays de la Loire (Region 12) - IDs 86 à 90
(86, '44000', 'Nantes', 2.00),
(87, '49000', 'Angers', 1.80),
(88, '53000', 'Laval', 1.50),
(89, '72000', 'Le Mans', 1.80),
(90, '85000', 'La Roche-sur-Yon', 1.60),

-- Bourgogne-Franche-Comté (Region 2) - IDs 13 à 20
(13, '21000', 'Dijon', 1.80),
(14, '25000', 'Besançon', 1.70),
(15, '39000', 'Lons-le-Saunier', 1.50),
(16, '58000', 'Nevers', 1.50),
(17, '70000', 'Vesoul', 1.40),
(18, '71000', 'Mâcon', 1.50),
(19, '89000', 'Auxerre', 1.50),
(20, '90000', 'Belfort', 1.50),

-- Bretagne (Region 3) - IDs 21 à 24
(21, '22000', 'Saint-Brieuc', 1.70),
(22, '29000', 'Quimper', 1.80),
(23, '35000', 'Rennes', 2.00),
(24, '56000', 'Vannes', 1.80),

-- Centre-Val de Loire (Region 4) - IDs 25 à 30
(25, '18000', 'Bourges', 1.60),
(26, '28000', 'Chartres', 1.60),
(27, '36000', 'Châteauroux', 1.40),
(28, '37000', 'Tours', 1.90),
(29, '41000', 'Blois', 1.60),
(30, '45000', 'Orléans', 1.80),

-- Corse (Region 5) - IDs 31, 32
(31, '20100', 'Ajaccio', 2.00),
(32, '20200', 'Bastia', 1.90),

-- Grand Est (Region 6) - IDs 33 à 42
(33, '08000', 'Charleville-Mézières', 1.50),
(34, '10000', 'Troyes', 1.60),
(35, '51100', 'Reims', 1.90),
(36, '52000', 'Chaumont', 1.40),
(37, '54000', 'Nancy', 1.90),
(38, '55000', 'Bar-le-Duc', 1.40),
(39, '57000', 'Metz', 1.90),
(40, '67000', 'Strasbourg', 2.10),
(41, '68000', 'Colmar', 1.80),
(42, '88000', 'Épinal', 1.50),

-- Normandie (Region 9) - IDs 56 à 60
(56, '14000', 'Caen', 1.90),
(57, '27000', 'Évreux', 1.50),
(58, '50000', 'Saint-Lô', 1.40),
(59, '61000', 'Alençon', 1.40),
(60, '76000', 'Rouen', 1.90),

-- Nouvelle-Aquitaine (Region 10) - IDs 61 à 72
(61, '16000', 'Angoulême', 1.60),
(62, '17000', 'La Rochelle', 1.90),
(63, '19000', 'Tulle', 1.40),
(64, '23000', 'Guéret', 1.30),
(65, '24000', 'Périgueux', 1.50),
(66, '33000', 'Bordeaux', 2.20),
(67, '40000', 'Mont-de-Marsan', 1.50),
(68, '47000', 'Agen', 1.60),
(69, '64000', 'Pau', 1.80),
(70, '79000', 'Niort', 1.50),
(71, '86000', 'Poitiers', 1.70),
(72, '87000', 'Limoges', 1.70),

-- Outre-mer - IDs 97 à 101
(97, '97100', 'Basse-Terre', 1.50),
(98, '97300', 'Cayenne', 1.50),
(99, '97200', 'Fort-de-France', 1.80),
(100, '97600', 'Dzaoudzi', 1.40),
(101, '97400', 'Saint-Denis', 1.80),
(97, '97100', 'Pointe-à-Pitre', 1.50),
(98, '97300', 'Kourou', 1.50),
(99, '97200', 'Le Lamentin', 1.80),
(100, '97600', 'Mamoudzou', 1.40),
(101, '97400', 'Saint-Paul', 1.80);

/*============================================================================================================================================*/
/*============================================================================================================================================*/
/* INSERTIONS QUATRIEME NIVEAU                                                                                                                */
/*============================================================================================================================================*/
/*============================================================================================================================================*/ 

/*==============================================================*/
/* Table : adresse (130 adresses)                                */
/*==============================================================*/

INSERT INTO adresse (idville, numerorue, nomrue) VALUES 

(1, 10, 'Rue de Rivoli'), 
(2, 5, 'Avenue du Château'), 
(3, 1, 'Place de l''Hôtel de Ville'), 
(4, 15, 'Rue Grande'), 
(5, 22, 'Boulevard de la République'), 
(6, 7, 'Rue du Général de Gaulle'), 
(7, 3, 'Place du Marché'), 
(8, 42, 'Avenue Victor Hugo'), 
(9, 11, 'Rue du Lac'), 
(10, 8, 'Rue de la Cathédrale'), 
(11, 19, 'Boulevard Gambetta'), 
(12, 1, 'Quai des Thermes'), 
(13, 27, 'Rue de la Gare'), 
(14, 33, 'Avenue Jean Jaurès'), 
(15, 12, 'Place de la Victoire'), 
(16, 55, 'Rue des Vignes'), 
(17, 2, 'Rue de l''Église'), 
(18, 14, 'Rue du Moulin'), 
(19, 6, 'Impasse des Pins'), 
(20, 29, 'Rue du Vieux Port'), 
(21, 31, 'Avenue de la Mer'), 
(22, 17, 'Boulevard des Plages'), 
(23, 4, 'Rue des Remparts'), 
(24, 78, 'Promenade des Anglais'), 
(25, 101, 'Boulevard de la Croisette'), 
(26, 23, 'Rue Meynadier'), 
(27, 8, 'Place aux Herbes'), 
(28, 16, 'Cours Mirabeau'), 
(29, 3, 'Rue d''Italie'), 
(30, 40, 'Rue de la République'), 
(31, 2, 'Place du Palais'), 
(32, 18, 'Rue des Tanneurs'), 
(33, 9, 'Rue du Sapin'), 
(34, 12, 'Rue Nationale'), 
(35, 21, 'Grand Rue'), 
(36, 1, 'Rue de la Paix'), 
(37, 5, 'Rue Saint-Guillaume'), 
(38, 22, 'Place de la Liberté'), 
(39, 45, 'Rue de Lille'), 
(40, 19, 'Rue Solférino'), 
(41, 13, 'Rue de la Soif'), 
(42, 30, 'Rue Saint-Jean'), 
(43, 67, 'Avenue de la Plage'), 
(44, 1, 'Place du Capitole'), 
(45, 10, 'Place de la Comédie'), 
(46, 25, 'Rue de l''Ancien Courrier'), 
(47, 5, 'Boulevard Henri IV'), 
(48, 11, 'Quai de la Daurade'), 
(49, 14, 'Rue Foch'), 
(50, 7, 'Quai de la Fosse'),
(1, 18, 'Avenue des Champs-Élysées'),
(1, 6, 'Rue Mouffetard'),
(1, 75016, 'Avenue Foch'),
(1, 2, 'Boulevard Saint-Germain'),
(1, 21, 'Quai d''Orsay'),
(1, 4, 'Place des Vosges'),
(1, 123, 'Boulevard de Sébastopol'),
(1, 29, 'Rue de Rennes'),
(1, 36, 'Rue de Lutèce'),
(1, 1, 'Place de la Concorde'),
(10, 1, 'Place Bellecour'),
(10, 15, 'Quai Jean Moulin'),
(10, 2, 'Rue du Bœuf'),
(10, 45, 'Cours Lafayette'),
(10, 3, 'Place de la Croix-Rousse'),
(10, 99, 'Boulevard des Belges'),
(10, 5, 'Rue Mercière'),
(10, 12, 'Place Antonin Poncet'),
(20, 1, 'La Canebière'),
(20, 34, 'Quai du Port'),
(20, 12, 'Rue Sainte'),
(20, 58, 'Avenue du Prado'),
(20, 139, 'Boulevard Michelet'),
(20, 4, 'Place Castellane'),
(20, 2, 'Rue de la République'),
(20, 68, 'Avenue Pierre Mendès France'),
(24, 1, 'Place Masséna'),
(24, 12, 'Avenue Jean Médecin'),
(24, 3, 'Rue de la Préfecture'),
(24, 7, 'Rue de France'),
(24, 15, 'Quai des États-Unis'),
(44, 1, 'Grand''Place'),
(44, 12, 'Rue Esquermoise'),
(44, 33, 'Boulevard de la Liberté'),
(44, 5, 'Place du Général de Gaulle'),
(65, 1, 'Place du Capitole'),
(65, 2, 'Rue du Taur'),
(65, 17, 'Place Saint-Sernin'),
(65, 48, 'Allées Jean Jaurès'),
(68, 1, 'Place de la Bourse'),
(68, 15, 'Cours de l''Intendance'),
(68, 89, 'Rue Sainte-Catherine'),
(68, 3, 'Place du Parlement'),
(80, 1, 'Place Royale'),
(80, 3, 'Rue Crébillon'),
(80, 4, 'Passage Pommeraye'),
(80, 11, 'Quai de la Motte Rouge'),
(40, 1, 'Place Kléber'),
(23, 1, 'Place de la Mairie'),
(28, 1, 'Place Plumereau'),
(30, 1, 'Place du Martroi'),
(37, 1, 'Place Stanislas'),
(9, 1, 'Place de Jaude'),
(13, 1, 'Place de la Libération'),
(59, 1, 'Place de la Cathédrale'),
(76, 1, 'Place de la Comédie'),
(73, 1, 'Place de l''Horloge'),
(79, 1, 'Place de la République'),
(4, 1, 'Place du Square'),
(8, 1, 'Place du Breuil'),
(12, 10, 'Rue Carnot'),
(15, 1, 'Place du Maréchal Leclerc'),
(16, 1, 'Place de l''Hôtel de Ville'),
(17, 1, 'Place de la République'),
(18, 1, 'Place Lamartine'),
(19, 1, 'Place du Marché aux Fleurs'),
(21, 1, 'Place du Guesclin'),
(22, 1, 'Place de la Tour d''Auvergne'),
(25, 1, 'Place Jacques Cœur'),
(26, 1, 'Place des Halles'),
(31, 1, 'Place Foch'),
(33, 1, 'Place Ducale'),
(36, 1, 'Grande Rue'),
(42, 1, 'Place Hérold'),
(45, 1, 'Place des Héros'),
(60, 1, 'Place du Maréchal Foch'),
(66, 1, 'Place Charles de Gaulle'),
(72, 1, 'Place des Foires'),
(84, 1, 'Place de la Libération'),
(85, 1, 'Place Napoléon');

/*============================================================================================================================================*/
/*============================================================================================================================================*/
/* INSERTIONS CINQUIEME NIVEAU                                                                                                                */
/*============================================================================================================================================*/
/*============================================================================================================================================*/ 

/*==============================================================*/
/* Table : utilisateur (50 utilisateurs)                        */
/*==============================================================*/

INSERT INTO utilisateur (   idadresse, iddate,
                            pseudonyme, email, email_verified_at, password, telephoneutilisateur, phone_verified, identity_verified, solde,
                            remember_token, two_factor_secret, two_factor_recovery_codes, two_factor_confirmed_at) VALUES

(1,44087,'Delsinor','janvier.sarah2417@icloud.com','2020-09-14 08:45:12','$2y$12$8jypVZNwBUoLF0FbEiB6..V3Ze66GUC9T0Qx11txGGViI0XHg87de','0695638456',TRUE,TRUE,301.52,NULL,NULL,NULL,NULL),
(2,44125,'Varion','d_simon@google.net','2020-10-22 15:30:01','$2y$12$eTRPeo7ygyvdnPi7cE06P.1mJvSCJwdXEuIkktEgmDbGC.bGG1Q46','0717374228',TRUE,TRUE,493.23,NULL,NULL,NULL,NULL),
(3,44152,'MoonWarden','rachel_dam780@yahoo.com','2020-11-18 22:10:55','$2y$12$WFh7l0NkHlI5kx6QiJD8g.jy/Z76ELmhpssJ6c6VTNDeA3S2E0aeC','0729484225',TRUE,FALSE,655.85,NULL,NULL,NULL,NULL),
(4,44165,'Asteron','jeanne-borde@yahoo.com','2020-12-01 11:05:33','$2y$12$opkU7lgor32quC5VhJvywu6aDmtzTBl873iid3mWcWYaEXz3HqotW','0705434475',TRUE,TRUE,458.40,NULL,NULL,NULL,NULL),
(6,44634,'Velkanor','alexisgeelen2649@yahoo.net','2022-02-20 04:50:18','$2y$12$ENkHx6xRFQKWXADme1pbYuv2twEDNJAiH7MM0xNe3Fl/0aUwqgOJy','0639185787',TRUE,TRUE,384.45,NULL,NULL,NULL,NULL),
(7,43951,'Solarys','alexandre.brisbois@yahoo.org','2022-03-15 14:12:03','$2y$12$5jqm3bKfrmDky3i270pScOYAU4gx..4Ce4J8JRq5nF/uieLm2G8iG','0722052574',TRUE,TRUE,438.70,NULL,NULL,NULL,NULL),
(8,43971,'Solaryn','olivierholt8942@hotmail.couk','2020-05-01 09:00:00','$2y$12$gguq3YDiaUEQ/iM.LM64AOMKaaca90qvQb7OeNTwZzXyCL2A53lKG','0622562347',TRUE,TRUE,602.64,NULL,NULL,NULL,NULL),
(9,44016,'Cyrenith','a.kim@protonmail.org','2020-05-21 23:45:10','$2y$12$tlbBS1EQF/.CIDPrQpkyGuayQgzH3PNdZXX6e92WTbi0Z.qUjszpm','0703877291',TRUE,FALSE,558.85,NULL,NULL,NULL,NULL),
(11,43302,'Serynox','t.jessica9600@outlook.com','2020-07-05 18:30:44','$2y$12$/4QU8isstqsG/ayoPa64TuRq4HSx.J2mA4unWRKYcS9Vc6RVS/una','0753618415',TRUE,TRUE,882.37,NULL,NULL,NULL,NULL),
(12,43229,'MoonWarden','laneleila@outlook.couk','2020-09-01 10:15:59','$2y$12$0DP1KWGFIUM4AOAQg6FPZO6Za2vCsxdqwqD32htFom0nJeb2GTdZO','0623466333',TRUE,TRUE,30.85,NULL,NULL,NULL,NULL),
(13,43372,'Ormalia','tanguy-monet5088@aol.couk','2018-07-22 20:05:11','$2y$12$WLbioCUjZDv1KskCmQn08.MUwIMQdT69NGtUkrapJNzs139B5rKH2','0698143673',TRUE,FALSE,439.28,NULL,NULL,NULL,NULL),
(14,43387,'Cyrenith','jerome_chaput@yahoo.org','2018-05-10 16:40:32','$2y$12$JMZaWsK3tAuGcQEZIfeyMuooDNXZ8pC4npKMGPjZDNvTgKVPQz.lG','0622505865',TRUE,TRUE,402.56,NULL,NULL,NULL,NULL),
(16,43823,'Cyrenith','l-emile8112@protonmail.com','2018-09-30 13:13:13','$2y$12$C/hUKfOlXychxj2x.F.VROfONku3VgA0qM8Qgzp6LcJFOc2iuyRje','0745648808',TRUE,FALSE,794.17,NULL,NULL,NULL,NULL),
(17,43844,'Varion','ocane_maes@icloud.couk','2018-10-15 21:28:49','$2y$12$S1/c9gxJEHkx.joIXylSAeir88nJkyyJVKwlk.KnF2H8Phv.bkt5G','0761917131',TRUE,TRUE,649.67,NULL,NULL,NULL,NULL),
(18,44620,'Valkyra','valerie-lemaire@google.couk','2019-12-01 02:17:38','$2y$12$2gMQO4y75PNik67JhsxXcefz1UxE3TzTRAPHW4XbnVpNMhkEPCtkC','0741448125',TRUE,FALSE,783.14,NULL,NULL,NULL,NULL),
(19,44629,'Quilnor','j-valentin@yahoo.ca','2019-12-25 17:50:00','$2y$12$duTlQ3LjODOmjNHXeXe9T.HJhVzFxfSHS2jNTArb.Gu/jBrY4fcoK','0648633468',TRUE,TRUE,316.69,NULL,NULL,NULL,NULL),
(21,44967,'Silvaro','b-helene7999@yahoo.com','2020-01-15 11:11:11','$2y$12$tN4zeZd5kKwJmOg/FcajnuLuEWtBpVbPsHx.Sso.LBJ60/ohFSsri','0746100284',TRUE,TRUE,687.22,NULL,NULL,NULL,NULL),
(22,45075,'Halcyonex','gauthiertravers1649@google.edu','2022-03-01 07:07:07','$2y$12$aRXN2xM3mEJ8VMM61Y0qbuYprMScndXRt6.XfN0CWoYOkcL9u6upK','0771141213',TRUE,FALSE,183.50,NULL,NULL,NULL,NULL),
(23,45156,'NovaLune','g_dewitte@yahoo.couk','2022-03-10 14:25:36','$2y$12$OcCMaq8.MqcuS2f22YDhNeD.CH5OKe6UW6pBC5AZiVI.Yxtd3xTXS','0667232663',TRUE,FALSE,478.38,NULL,NULL,NULL,NULL),
(24,45173,'EchoFlare','g_rachel5782@google.edu','2020-08-01 12:34:56','$2y$12$Tx0iHWdKbJtnUdly4yeI5OjpBw56ofZan/vQuL6JrtSqivtUrSuTi','0652211742',TRUE,TRUE,360.62,NULL,NULL,NULL,NULL),
(26,45298,'Bravonex','brisbois-cindy@icloud.ca','2023-02-11 10:15:22','$2y$12$yPF2IqjxixROzkur2GcfBuJ41Kt0CmwTKb2eQ60UhlJeNv3dK.YMS','0697518281',TRUE,TRUE,391.58,NULL,NULL,NULL,NULL),
(27,45312,'Kymora','lleila@google.com','2023-05-30 18:45:00','$2y$12$L..78tC8x/k9r0l.uLZD2uOJvuHZISJVl1UCC88TupvuxS7IgAxKy','0616263732',TRUE,TRUE,432.11,NULL,NULL,NULL,NULL),
(28,45368,'Kymora','v_laurie7403@aol.com','2023-08-19 09:12:48','$2y$12$m1KYB8JO/Q/mD5dS3maVie9MpQ8sstGlM21XfvQbNvoQDU7hgR69i','0757291446',TRUE,TRUE,658.40,NULL,NULL,NULL,NULL),
(29,45382,'DriftShade','nora.cruyssen@hotmail.couk','2023-09-05 22:33:10','$2y$12$tMnSGV0tuYzXmvrq1OYayepMsOt9L4ws/zH8bvTtKX6BtHGbb5KSC','0678662325',TRUE,TRUE,51.46,NULL,NULL,NULL,NULL),
(31,45439,'Fluxyne','rachel-bezuindenhout@google.couk','2023-12-01 11:00:00','$2y$12$KA7likTytLofcyZZrYowEe.DLHp1SFeXo2KSECOpcXLu6i8UxODA.','0683883328',TRUE,TRUE,6.90,NULL,NULL,NULL,NULL),
(32,45452,'Fyrenza','v.dylan4636@aol.org','2024-01-08 16:28:17','$2y$12$0fZ7O/stLO8euwB10LVejubn0MCrnoXKFOOqFqRPWQnCJ9hLf.zui','0744186257',TRUE,TRUE,789.56,NULL,NULL,NULL,NULL),
(33,45463,'Kymora','simon.garcon1638@hotmail.couk','2024-01-22 08:55:43','$2y$12$sFPz8RGXSHqPIjmJdt7q5usrgAH03UDOoodmuVwBOex8tzkkxG8o.','0719540158',TRUE,TRUE,121.52,NULL,NULL,NULL,NULL),
(36,45500,'Tyvanna','v_juliette1960@hotmail.com','2024-03-18 20:30:15','$2y$12$Nt6Zj.NuLeLxc5A.n6g5au4XITxjQcLp/5QLguUy/Zj29edOa323O','0731686729',TRUE,TRUE,527.53,NULL,NULL,NULL,NULL),
(37,45522,'Delsinor','pmax9643@hotmail.edu','2024-04-01 00:00:01','$2y$12$viRKySvklGq3fSAbcYWbTOY7uck15.OE.jUj44wkyAI918lS6Kj9i','0626785246',TRUE,TRUE,175.44,NULL,NULL,NULL,NULL),
(38,44203,'Elionyx','b_mlissa4@aol.org','2024-04-25 15:15:15','$2y$12$WVJCG2yjQOeEAxtQmUXMb.ukunarQ8iKwtwDcthrLhwSyftnbeUDy','0744910127',TRUE,TRUE,330.14,NULL,NULL,NULL,NULL),
(41,43999,'Lynaro','emilie-blanc@icloud.couk','2024-05-28 13:05:00','$2y$12$0pGhsqpzRH6KyePYKezoFuOen4Hjx8t7Jt96T8jCc58kajEwiso0C','0674157020',TRUE,TRUE,521.65,NULL,NULL,NULL,NULL),
(42,43343,'Nyxian','e.florent@aol.couk','2024-06-10 17:30:44','$2y$12$bKPnGLzzajOZrayQCjETlu1aMyL/lwLM9NSeayHD5OUFfIGVD21/C','0728285148',TRUE,TRUE,309.37,NULL,NULL,NULL,NULL),
(43,45417,'Aerionyx','b.charlotte9448@outlook.org','2024-06-21 09:09:09','$2y$12$ZWPHHcbeNYLoEnuiH7RuluGfDJVaev01O7SLmVVug.u7JkTXHJiyK','0688335384',TRUE,TRUE,652.76,NULL,NULL,NULL,NULL),
(46,45474,'Valkyra','tristanprinsen@yahoo.edu','2024-07-28 14:00:00','$2y$12$1bWNbt20rYnY9E8gdIA5ReYY0nlwcCvAAhYvvWcaH3uxfEIZ3Q88u','0620373013',TRUE,TRUE,463.90,NULL,NULL,NULL,NULL),
(47,45535,'Bravonex','d-blanc4650@google.edu','2024-08-08 10:10:10','$2y$12$5gnBU9unTve02hxR/JOPDe4IYdAlk8WCCIQZZBdtJ/WIx4QFaNwhK','0711557858',TRUE,TRUE,552.30,NULL,NULL,NULL,NULL),
(48,43829,'Silvaro','nora.berg@hotmail.net','2024-08-19 18:50:25','$2y$12$Fhx/6YTwS1vIB4VtS8E/su4F0dE2LfgsY4IiophZhtdFD2AXidcjC','0781877181',TRUE,TRUE,608.85,NULL,NULL,NULL,NULL),
(26,45250,'Eltharis','c_lemaire691@icloud.org','2021-01-08 19:22:47','$2y$12$N.poygLhDdmIguSReRfb7O18wp7RJzQ52ctn21X8wgVcTH9ZpW3Hu','0689771334',TRUE,TRUE,722.63,NULL,NULL,NULL,NULL),
(10,45350,'Skyrune','d.koopman4170@protonmail.org','2020-06-18 12:00:25','$2y$12$q.vl3yBn.k1/zGjOR8piBenGopN7OIAVoSsJmHGomudFSrLtKi55e','0797861221',TRUE,TRUE,676.26,NULL,NULL,NULL,NULL),
(15,45428,'Vorlune','v.ali4242@protonmail.couk','2018-09-01 08:00:00','$2y$12$8WyPSXcggVW1kDuVl9AzEOeoDIfzYKJ89biGqgtLPqf2w5ec/MDMO','0608239111',TRUE,TRUE,876.44,NULL,NULL,NULL,NULL),
(34,45487,'Cyrenith','h_camille@protonmail.com','2024-02-14 19:10:02','$2y$12$vaQSqz7Oovn/F2AZgHrATOcPQI/hImYuCZkJ/0dLqHhgXyCCKTG8O','0685277269',TRUE,FALSE,670.00,NULL,NULL,NULL,NULL),
(39,44611,'Tyvanna','stephanie_cruyssen@yahoo.ca','2024-05-06 11:40:33','$2y$12$EdevqzEqPhTUAHguGJ9WjOXXOuNfWbSWS7jql6wsdlrml.mst7eN2','0738540689',TRUE,TRUE,610.73,NULL,NULL,NULL,NULL),
(44,44074,'Elionyx','la.dubois@hotmail.com','2024-07-02 21:21:21','$2y$12$RN7uMfk7z0VTTlcF7ZIazuqseHh2NU7ZAkd9TFCFXN7QTKuJRp.x6','0755651492',TRUE,TRUE,800.29,NULL,NULL,NULL,NULL),
(49,43799,'Teralis','tristan_vanalphen8272@yahoo.couk','2024-09-01 08:00:00','$2y$12$NjeRIs7yilWXk2XLJ..MAe/Zp.RUZRljfbGOHtlAAD3qfxjzTb6ma','0666374465',TRUE,FALSE,634.46,NULL,NULL,NULL,NULL),
(30,44043,'Zelyrion','h-maes@protonmail.org','2019-12-31 23:59:59','$2y$12$SXLygkoQ79kycgVxwr4opeBcWGXFl4vaunnF5mUNCh0qq6DmpyTgW','0710581186',TRUE,FALSE,324.76,NULL,NULL,NULL,NULL),
(25,45260,'Nyxian','qrademaker@outlook.ca','2020-08-25 09:19:43','$2y$12$Yqn/I.CNL6VKRQ5.F6aj0uHsRiB0jvAHIiFsts.35H4r4ss384TAm','0772562261',TRUE,TRUE,820.50,NULL,NULL,NULL,NULL),
(30,45406,'MoonWarden','a-ali@aol.net','2023-11-21 14:05:59','$2y$12$0Fv35yUrtqxi84erJ8deEOEfpZ3hroF4UEo30KTmjp7siIXKiSKIe','0607858755',TRUE,TRUE,924.62,NULL,NULL,NULL,NULL),
(35,45511,'Nexilo','marchandelisabeth3377@google.edu','2024-02-29 12:00:00','$2y$12$H4eLsRsll3MNHvM.BMTx0OIbZFhpwXiWgYM54XI7nv.u97sy3w9Py','0677117676',TRUE,TRUE,977.10,NULL,NULL,NULL,NULL),
(40,45335,'Vanyth','c-berger3570@protonmail.com','2024-05-17 06:22:58','$2y$12$7NfqDgpV5R4a6.efu.i0feVFe7oiP64ArLb2ogcH1xLiK0IbJTc3a','0678877669',TRUE,TRUE,973.61,NULL,NULL,NULL,NULL),
(45,44067,'Vanyth','c-glenn7427@icloud.org','2024-07-15 12:45:30','$2y$12$/dyX4DJiOjQbwMYXT4ndYuKuy./JjxvYPNwXUsrF.kc3VvywJt3HW','0678188426',TRUE,TRUE,934.58,NULL,NULL,NULL,NULL),
(50,45546,'EchoFlare','igeelen@yahoo.edu','2024-09-12 16:16:16','$2y$12$mS4ttJ3QRQZU8JoHuEp/8OrYpmtgLQWDzq.5CSu.1A9azbBY29XXG','0677425458',TRUE,TRUE,815.79,NULL,NULL,NULL,NULL),
(1,44087,'svc_location','service.location@leboncoin.local','2026-03-25 09:00:00','$2a$11$TLEucTKy3A3Zn3C6x4Wgy.SLEXObaeIMvQ88mR.2MSwTibscWXGCq','0600000051',TRUE,TRUE,0,NULL,NULL,NULL,NULL),
(2,44125,'svc_compta','service.comptabilite@leboncoin.local','2026-03-25 09:00:00','$2a$11$TLEucTKy3A3Zn3C6x4Wgy.SLEXObaeIMvQ88mR.2MSwTibscWXGCq','0600000052',TRUE,TRUE,0,NULL,NULL,NULL,NULL),
(3,44152,'svc_contentieux','service.contentieux@leboncoin.local','2026-03-25 09:00:00','$2a$11$TLEucTKy3A3Zn3C6x4Wgy.SLEXObaeIMvQ88mR.2MSwTibscWXGCq','0600000053',TRUE,TRUE,0,NULL,NULL,NULL,NULL);

/*============================================================================================================================================*/
/*============================================================================================================================================*/
/* INSERTIONS SIXIEME NIVEAU                                                                                                                */
/*============================================================================================================================================*/
/*============================================================================================================================================*/ 

/*==============================================================*/
/* Table : annonce (100 annonces)                               */
/*==============================================================*/

INSERT INTO annonce (idadresse, iddate, idheuredepart, idtypehebergement, idheurearrivee, idutilisateur, titreannonce, descriptionannonce, nombreetoilesleboncoin, montantacompte, pourcentageacompte, prixnuitee, minimumnuitee, possibiliteanimaux, nombrebebesmax, possibilitefumeur, capacite, nbchambres, estverifie) VALUES

(51,44155,7,6,48,48,'Appartement cosy en centre-ville','Charmant appartement récemment rénové, situé au cœur du centre-ville, proche de toutes les commodités.',2,52,NULL,90,4,true,4,true, 4, 2, true),
(52,44613,46,4,31,24,'Maison familiale avec grand jardin','Maison familiale spacieuse avec grand jardin arboré, idéale pour les familles à la recherche de tranquillité.',4,NULL,50,156,3,true,4,false, 8, 4, true),
(53,44439,43,6,33,48,'Studio idéal pour étudiant','Studio fonctionnel et meublé, parfait pour un étudiant ou un jeune actif.',5,51,NULL,55,1,true,3,true, 2, 1, true),
(54,43337,29,3,24,48,'Loft moderne en plein centre','Loft moderne avec belle hauteur sous plafond, dans un quartier dynamique et recherché.',4,137,NULL,98,3,true,3,false, 4, 1, true),
(55,45430,34,9,15,47,'Appartement lumineux avec balcon','Appartement lumineux avec balcon orienté sud, vue dégagée sans vis-à-vis.',3,59,NULL,153,2,true,3,false, 4, 2, true),
(56,45839,47,2,29,24,'Charmante maison proche des écoles','Jolie maison entièrement rénovée, à proximité des écoles et commerces.',2,NULL,76,47,1,true,5,true, 6, 3, true),
(57,45835,25,6,16,29,'Studio rénové et meublé','Studio calme en résidence sécurisée, à deux minutes du métro.',3,73,NULL,141,3,true,1,false, 2, 1, true),
(58,44865,46,6,25,2,'Appartement spacieux vue dégagée','Appartement spacieux avec grande terrasse privative, idéal pour les repas en extérieur.',3,NULL,48,168,3,true,4,false, 6, 3, true),
(59,43983,11,4,32,49,'Maison de village rénovée','Maison de village au charme ancien, restaurée avec goût.',2,NULL,88,100,3,true,4,true, 6, 3, true),
(60,44077,46,1,44,23,'Loft industriel très lumineux','Appartement en dernier étage avec ascenseur, très lumineux et bien isolé.',4,142,NULL,104,3,true,0,true, 4, 1, true),
(61,44813,10,2,19,25,'Appartement proche des transports','Maison avec piscine chauffée et terrain clos, parfaite pour les familles.',1,NULL,15,59,4,true,2,true, 8, 4, true),
(62,44956,40,8,3,38,'Maison avec piscine privée','Studio pratique avec kitchenette équipée, proche université et transports.',5,NULL,59,134,2,false,4,false, 2, 1, true),
(63,44083,43,9,43,24,'Studio calme dans résidence','Appartement moderne dans résidence récente, avec parking sécurisé.',2,76,NULL,111,1,true,0,true, 4, 2, true),
(64,44644,47,2,12,24,'Appartement terrasse plein sud','Maison avec garage et sous-sol complet, dans un quartier résidentiel.',1,113,NULL,54,3,true,2,true, 6, 3, true),
(65,45422,3,8,29,24,'Jolie maison à la campagne','Studio refait à neuf, idéal pour un premier logement.',2,137,NULL,71,2,true,4,false, 2, 1, true),
(66,45776,30,2,30,27,'Duplex moderne centre-ville','Appartement climatisé avec grande pièce de vie et cuisine ouverte.',2,58,NULL,59,3,true,2,false, 5, 2, true),
(67,43369,46,4,1,24,'Studio proche de la gare','Maison en campagne avec belle vue dégagée sur la nature.',3,NULL,69,158,4,true,3,false, 6, 3, true),
(68,45851,40,2,41,46,'Appartement rénové récemment','Appartement proche de la gare, parfait pour un quotidien sans voiture.',4,NULL,71,76,3,true,3,true, 4, 2, true),
(69,45290,10,8,44,6,'Maison plain-pied quartier calme','Maison plain-pied très bien entretenue, aucune rénovation à prévoir.',2,147,NULL,139,2,true,0,false, 6, 3, true),
(70,45654,3,6,28,48,'Appartement en dernier étage','Studio entièrement meublé, prêt à habiter immédiatement.',5,NULL,64,71,1,true,4,true, 2, 1, true),
(71,45701,32,4,8,38,'Studio fonctionnel bien situé','Appartement avec cuisine équipée et rangements, très pratique au quotidien.',2,103,NULL,166,2,true,2,true, 4, 2, true),
(72,44925,9,5,37,50,'Maison en bord de mer','Maison spacieuse avec quatre chambres, idéale pour grande famille.',5,NULL,80,183,1,false,2,false, 10, 5, true),
(73,43986,23,6,34,29,'Appartement avec parking privé','Studio lumineux dans un quartier calme et recherché.',2,NULL,76,165,2,true,2,false, 2, 1, true),
(74,43825,6,1,13,24,'Charmant studio hyper centre','Appartement en résidence sécurisée avec ascenseur et local vélo.',4,NULL,16,115,1,true,3,false, 4, 2, true),
(75,44649,47,3,27,24,'Appartement vue sur parc','Maison ancienne rénovée avec goût, pierres et poutres apparentes.',4,NULL,85,89,4,true,5,false, 6, 3, true),
(76,45866,45,3,4,45,'Maison avec grandes pièces','Studio bien agencé avec salle de bain moderne.',1,70,NULL,165,5,true,3,false, 2, 1, true),
(77,43724,9,2,42,31,'Studio idéal court séjour','Appartement avec vue sur parc, proche commerces et transports.',2,89,NULL,65,5,true,5,false, 4, 2, true),
(78,45930,36,6,44,48,'Appartement proche commerces','Maison avec terrasse couverte et grand terrain, parfaite pour les repas en été.',5,80,NULL,173,4,true,2,true, 8, 4, true),
(79,43398,23,7,37,10,'Maison récente très lumineuse','Studio calme et isolé, parfait pour télétravailler sereinement.',3,NULL,47,163,4,false,3,false, 2, 1, true),
(80,45221,12,7,10,41,'Studio meublé prêt à vivre','Appartement rénové récemment, aucun travaux à prévoir.',3,115,NULL,86,2,true,2,true, 4, 2, true),
(81,45114,32,6,14,46,'Appartement avec cuisine équipée','Maison moderne avec prestations haut de gamme, dans un environnement paisible.',3,95,NULL,53,3,true,2,false, 7, 4, true),
(82,43201,7,4,10,25,'Maison avec terrasse couverte','Studio idéal pour investissement locatif, forte demande dans le secteur.',2,138,NULL,116,3,true,0,false, 2, 1, true),
(83,44490,23,6,40,46,'Studio en résidence sécurisée','Appartement situé dans une résidence récente avec ascenseur et parking.',5,NULL,55,100,3,false,5,false, 4, 2, true),
(84,43767,40,2,22,38,'Appartement à deux pas du métro','Maison avec dépendance aménageable, idéal projet familial ou professionnel.',2,NULL,93,153,5,true,3,true, 8, 4, true),
(85,43687,24,2,19,34,'Maison en lotissement calme','Studio proche des plages, parfait pour un pied-à-terre.',2,NULL,11,91,4,true,2,false, 2, 1, true),
(86,45545,43,9,11,24,'Studio petite surface optimisée','Appartement très lumineux avec fenêtres double vitrage et isolation neuve.',1,63,NULL,52,2,true,4,true, 4, 2, true),
(87,43671,12,8,28,38,'Appartement idéal colocation','Maison à la campagne, environnement calme sans voisins proches.',1,117,NULL,70,2,true,2,true, 6, 3, true),
(88,45700,18,8,26,45,'Belle maison avec garage','Studio au cœur du centre historique, proche de toutes commodités.',3,124,NULL,130,4,false,2,false, 2, 1, true),
(89,44388,45,7,5,41,'Studio au cœur du village','Appartement avec balcon et vue montagne, idéal pour les amoureux de nature.',4,120,NULL,92,3,true,3,false, 4, 2, true),
(90,45357,6,8,9,41,'Appartement entièrement refait','Maison à rénover, beau potentiel pour projet personnel ou investissement.',1,NULL,52,69,4,true,0,false, 6, 3, true),
(91,44866,32,7,35,5,'Maison avec vue montagne','Studio en parfait état, vendu entièrement équipé.',2,52,NULL,90,3,true,2,true, 2, 1, true),
(92,44340,24,5,19,34,'Studio pas cher bien placé','Appartement rénové avec goût, mélange de moderne et ancien.',1,NULL,98,57,5,true,4,false, 4, 2, true),
(93,45187,40,8,5,7,'Appartement standing centre historique','Maison proche océan, grande pièce de vie et jardin clos.',3,55,NULL,134,1,true,2,false, 6, 3, true),
(94,43372,4,1,36,42,'Maison avec dépendances','Studio dans résidence étudiante sécurisée, emplacement idéal.',1,70,NULL,84,4,false,1,true, 2, 1, true),
(95,45155,10,9,6,24,'Studio au calme absolu','Appartement spacieux avec trois chambres, idéal pour colocation.',2,NULL,53,54,3,true,5,false, 6, 3, true),
(96,44878,11,2,42,41,'Appartement pratique pour étudiant','Maison récente avec chauffage économique et matériaux modernes.',4,NULL,45,108,2,true,2,true, 7, 3, true),
(97,43405,17,6,38,48,'Maison pleine de charme','Studio lumineux au dernier étage, très faible vis-à-vis.',2,NULL,13,51,4,false,5,true, 2, 1, true),
(98,44052,12,6,16,46,'Studio dans quartier vivant','Appartement avec cuisine ouverte et salon spacieux.',3,NULL,15,150,2,false,0,true, 4, 2, true),
(99,45759,38,2,9,24,'Appartement proche université','Maison dans quartier résidentiel calme, proche écoles et parc.',2,66,NULL,69,1,true,4,true, 6, 3, true),
(100,45179,47,8,3,6,'Maison spacieuse et lumineuse','Studio entièrement refait, prêt à louer immédiatement.',3,NULL,73,155,3,false,2,false, 2, 1, true),
(101,44798,22,2,43,33,'Studio récent à louer','Appartement avec deux balcons, idéal pour profiter du soleil toute la journée.',3,NULL,53,100,4,true,3,false, 4, 2, true),
(102,44650,21,8,32,41,'Appartement avec grande terrasse','Maison en bordure de forêt, idéale pour amoureux de la nature.',3,50,NULL,173,5,true,5,false, 6, 3, true),
(103,44917,1,7,25,37,'Maison à deux niveaux','Studio avec belle hauteur sous plafond, possibilité mezzanine.',3,NULL,42,97,4,true,2,true, 2, 1, true),
(104,44855,41,6,13,20,'Studio dans résidence neuve','Appartement dans résidence de standing avec espaces verts.',1,100,NULL,166,5,false,4,false, 4, 2, true),
(105,43679,45,3,41,21,'Appartement proche du tram','Maison spacieuse avec atelier, idéale pour les bricoleurs.',1,NULL,28,94,5,true,2,false, 6, 3, true),
(106,43798,23,3,45,42,'Maison avec terrain arboré','Studio fonctionnel en plein centre-ville.',3,120,NULL,131,2,true,5,true, 2, 1, true),
(107,45785,8,2,14,32,'Studio en location saisonnière','Appartement en excellent état, vendu avec place de parking.',2,67,NULL,166,1,true,5,true, 4, 2, true),
(108,45645,46,6,46,24,'Appartement en parfait état','Maison ancienne rénovée, charme ancien préservé.',1,NULL,37,68,4,true,2,false, 6, 3, true),
(109,43258,14,4,26,24,'Ancienne maison rénovée','Studio parfait pour étudiant, proche de toutes commodités.',4,124,NULL,82,3,true,3,true, 2, 1, true),
(110,44705,30,7,23,26,'Studio parfait pour débuter','Appartement en dernier étage avec grande luminosité naturelle.',4,55,NULL,65,1,true,1,true, 4, 2, true),
(111,45183,19,4,40,28,'Appartement situé en centre historique','Maison avec grande terrasse et vue imprenable.',3,NULL,88,98,2,true,3,true, 6, 3, true),
(112,45656,21,2,41,27,'Maison calme à rénover','Studio dans quartier vivant, commerces à proximité immédiate.',2,115,NULL,143,3,true,1,false, 2, 1, true),
(113,44044,18,4,11,24,'Studio prix attractif','Appartement lumineux avec double exposition et cuisine équipée.',4,147,NULL,171,5,true,0,false, 4, 2, true),
(114,44545,22,8,24,20,'Appartement avec vue mer','Maison avec jardin paysagé, aucun vis-à-vis.',4,89,NULL,86,4,false,2,true, 6, 3, true),
(115,45078,8,1,42,39,'Maison isolée en forêt','Studio calme idéal télétravail.',1,NULL,64,53,3,true,4,true, 2, 1, true),
(116,45588,36,8,37,24,'Studio proche toutes commodités','Appartement rénové récemment, quartier recherché.',3,NULL,48,71,4,true,4,false, 4, 2, true),
(117,45674,45,9,25,24,'Appartement idéal investissement','Maison plein pied avec garage et buanderie.',5,80,NULL,146,1,true,2,false, 6, 3, true),
(118,43314,9,6,16,32,'Grande maison proche plages','Studio à deux pas du tramway.',2,80,NULL,174,2,true,4,false, 2, 1, true),
(119,45868,13,8,2,24,'Studio lumineux orientation sud','Appartement avec belle pièce de vie ouverte.',2,NULL,39,182,2,true,1,true, 4, 2, true),
(120,44783,38,4,39,1,'Appartement entièrement meublé','Maison à grand potentiel, idéal investisseurs.',3,64,NULL,104,2,true,1,false, 6, 3, true),
(121,44186,46,6,40,1,'Maison à fort potentiel','Studio cosy décoré avec goût.',2,NULL,89,182,4,true,5,true, 2, 1, true),
(122,45213,10,1,33,47,'Studio dans immeuble récent','Appartement dans résidence calme et sécurisée.',4,90,NULL,73,1,true,1,false, 4, 2, true),
(123,44873,46,7,38,7,'Appartement face à la mer','Maison en bord de rivière, cadre exceptionnel.',4,NULL,91,178,4,false,5,false, 7, 4, true),
(124,44654,24,4,1,1,'Maison familiale proche commerces','Studio spacieux rare sur le secteur.',4,NULL,7,116,3,true,0,true, 3, 2, true),
(125,43523,7,5,33,38,'Studio bien agencé','Appartement très bien situé, parfait pour première acquisition.',2,78,NULL,56,4,true,2,false, 4, 2, true),
(126,45859,35,6,37,45,'Appartement avec grand séjour','Maison familiale proche plages.',2,NULL,35,124,4,false,3,true, 6, 3, true),
(127,43638,20,3,44,50,'Maison en zone résidentielle','Studio lumineux dans immeuble récent.',2,NULL,37,134,2,true,4,false, 2, 1, true),
(128,43787,20,1,45,24,'Studio moderne rénové','Appartement moderne vendu meublé.',3,88,NULL,154,2,true,1,true, 4, 2, true),
(129,44359,39,3,8,1,'Appartement calme et spacieux','Maison avec cheminée et grand séjour.',4,63,NULL,59,5,true,2,false, 6, 3, true),
(130,45321,39,5,33,48,'Grande maison plein centre','Studio pratique avec nombreux rangements.',2,NULL,21,174,4,true,2,true, 2, 1, true),
(52,45012,18,3,12,12,'Studio compact avec terrasse','Petit studio avec terrasse exposée sud, idéal pour les jeunes actifs.',3,40,NULL,72,2,true,1,false, 2, 1, false),
(61,45245,25,6,18,18,'Maison chaleureuse en périphérie','Maison avec poêle à bois et jardin paysager, au calme.',4,95,NULL,140,3,true,2,true, 6, 3, false),
(73,44902,15,4,30,22,'Appartement rénové style industriel','Loft avec briques apparentes et grandes fenêtres.',5,110,NULL,165,2,true,2,false, 4, 2, false),
(64,44770,12,2,19,14,'Studio pratique proche tram','Studio avec coin nuit séparé et cuisine équipée.',2,NULL,25,82,1,true,1,false, 2, 1, false),
(90,44610,21,9,27,26,'Maison de plain-pied lumineuse','Grande baie vitrée donnant sur un jardin clos.',3,120,NULL,178,2,true,2,true, 6, 3, false),
(85,44312,9,5,22,30,'Appartement balcon filant','Appartement traversant avec long balcon filant.',4,75,NULL,134,2,true,1,false, 4, 2, false),
(78,45102,32,8,35,9,'Loft lumineux sous toit','Loft dernier étage avec poutres apparentes.',3,NULL,33,96,2,false,0,true, 3, 1, false),
(69,44881,5,1,11,13,'Maison en hameau calme','Petite maison en pierre avec cheminée.',2,55,NULL,101,3,true,2,false, 4, 2, false),
(57,44733,14,7,16,19,'Studio étudiant équipé','Studio meublé avec bureau et rangements.',1,NULL,12,58,1,false,1,false, 1, 1, false),
(60,44628,19,4,25,21,'Appartement proche parc','Appartement avec vue dégagée sur un parc arboré.',4,88,NULL,145,3,true,2,true, 4, 2, false),
(71,44592,8,6,20,16,'Maison à rénover partiellement','Maison offrant un fort potentiel après travaux.',1,NULL,18,69,4,true,0,false, 5, 2, false),
(75,45277,33,5,37,11,'Studio calme en fond de cour','Studio sur cour intérieure, très silencieux.',2,47,NULL,87,2,true,1,false, 2, 1, false),
(83,45390,27,3,33,8,'Appartement avec loggia','Appartement avec loggia fermée, idéal espace bureau.',3,NULL,29,112,2,true,2,true, 3, 2, false),
(88,44944,16,2,21,15,'Maison familiale rénovée','Grande pièce de vie et cuisine ouverte récente.',4,105,NULL,171,3,true,3,true, 7, 3, false),
(92,44511,22,4,29,17,'Studio fonctionnel centre-ville','Studio au pied des commerces et transports.',2,NULL,19,74,1,false,1,false, 2, 1, false),
(95,44476,11,6,17,23,'Appartement dernier étage','Appartement avec ascenseur et cave.',3,63,NULL,121,2,true,1,false, 3, 1, false),
(98,44699,24,8,32,28,'Maison avec véranda','Maison lumineuse grâce à une grande véranda.',2,72,NULL,136,2,true,2,true, 5, 3, false),
(102,45209,13,4,26,35,'Appartement proche université','Idéal étudiants, à deux arrêts du campus.',1,NULL,15,62,1,false,1,true, 2, 1, false),
(109,44724,6,9,14,40,'Studio moderne décoré','Studio récent décoré dans un style contemporain.',3,NULL,22,95,2,true,1,false, 2, 1, false),
(114,44805,28,2,40,44,'Maison en lisière de forêt','Maison avec terrasse bois et sentiers à proximité.',4,118,NULL,189,3,true,3,true, 7, 4, false),
(118,44970,17,6,23,4,'Appartement compact bien agencé','Plan optimisé, nombreux rangements intégrés.',2,NULL,27,88,1,false,1,false, 2, 1, false);

/*==============================================================*/
/* Table : professionnel (15 professionnels)                    */
/*==============================================================*/

INSERT INTO professionnel (idutilisateur, numsiret, nomsociete, secteuractivite) VALUES

(36, '83294191000015', 'Tech Innovante SAS', 'Informatique / Télécoms'),
(37, '42011122200021', 'Gourmet & Fils', 'Agroalimentaire'),
(38, '91022233300010', 'BatiSolide SARL', 'BTP / Matériaux de construction'),
(39, '78945612300033', 'EcoLogis Concept', 'Énergie / Environnement'),
(40, '55566677700019', 'Prestige Auto', 'Machines et équipements / Automobile'),
(41, '11122233300045', 'SantéPourTous EURL', 'Industrie pharmaceutique'),
(42, '44455566600012', 'Axa Assurance', 'Banque / Assurance'),
(43, '66677788800050', 'Carrefour Express', 'Commerce / Négoce / Distribution'),
(44, '99988877700011', 'L''Oréal Cosmétiques', 'Chimie / Parachimie'),
(45, '12312312300067', 'Transport Rapide SA', 'Transports / Logistique'),
(46, '32132132100014', 'Le Tissu Français', 'Textile / Habillement / Chaussure'),
(47, '65465465400022', 'Leclerc Services', 'Services aux entreprises'),
(48, '98798798700018', 'Editions Lumière', 'Édition / Communication / Multimédia'),
(49, '13579246800010', 'Vinci Construction', 'BTP / Matériaux de construction'),
(50, '24681357900025', 'Hôtel Bellevue', 'Tourisme - Restauration');

/*==============================================================*/
/* Table : particulier (35 particuliers)                        */
/*==============================================================*/

INSERT INTO particulier (idutilisateur, nomutilisateur, prenomutilisateur, civilite, iddate) VALUES

(1,'Janvier','Sarah', 'Monsieur', 15083),
(2,'Duval','Simon', 'Madame', 19769),
(3,'Dam','Rachel', 'Non spécifié', 34879),
(4,'Borde','Jeanne', 'Monsieur', 14329),
(5,'Geelen','Alexis', 'Madame', 33755),
(6,'Brisbois','Alexandre', 'Monsieur', 36180),
(7,'Holt','Olivier', 'Non spécifié', 13990),
(8,'Archambault','Kim', 'Monsieur', 18212),
(9,'Tremblay','Jessica', 'Non spécifié', 22779),
(10,'Lane','Leila', 'Monsieur', 28880),
(11,'Monet','Tanguy', 'Madame', 26224),
(12,'Chaput','Jerome', 'Madame', 20668),
(13,'Lachapelle','Emile', 'Monsieur', 36878),
(14,'Maes','Océane', 'Non spécifié', 15299),
(15,'Lemaire','Valerie', 'Monsieur', 21656),
(16,'Jonker','Valentin', 'Madame', 31881),
(17,'Berg','Helene', 'Madame', 30422),
(18,'Travers','Gauthier', 'Monsieur', 17089),
(19,'De_Witte','Grégoire', 'Non spécifié', 23878),
(20,'Garcon','Rachel', 'Monsieur', 15579),
(21,'Brisbois','Cindy', 'Non spécifié', 35379),
(22,'Lavigne','Leila', 'Madame', 28200),
(23,'Van_Aalsburg','Laurie', 'Monsieur', 14379),
(24,'Cruyssen','Nora', 'Monsieur', 15216),
(25,'Bezuindenhout','Rachel', 'Madame', 33279),
(26,'Van_Assen','Dylan', 'Non spécifié', 13889),
(27,'Garcon','Simon', 'Madame', 22335),
(28,'Villenueve','Juliette', 'Monsieur', 31533),
(29,'Plamondon','Max', 'Madame', 25102),
(30,'Brisbois','Mélissa', 'Non spécifié', 33880),
(31,'Blanc','Emilie', 'Monsieur', 14434),
(32,'Eikenboom','Florent', 'Non spécifié', 29879),
(33,'Bellamy','Charlotte', 'Monsieur', 23980),
(34,'Prinsen','Tristan', 'Madame', 13999),
(35,'Blanc','Danny', 'Non spécifié', 36379);

/*==============================================================*/
/* Table : attribuer                                            */
/*==============================================================*/

INSERT INTO attribuer (idutilisateur, idrole) VALUES
(51, 3),
(52, 4),
(53, 5);

/*==============================================================*/
/* Table : message (15 messages)                                */
/*==============================================================*/

INSERT INTO message (idutilisateurreceveur, iddate, idutilisateurexpediteur, contenumessage) VALUES

(5,44526, 6, 'Je voulais vous demander plus de photo. Cela est possible ?'),
(6,44527, 5, 'Bonjour, bien sûr. De quel produit s''agit-il exactement ? J''ai besoin de la référence.'),
(5,44528, 6, 'C''est pour l''ordinateur portable "Quantum Z". Merci !'),
(6,44529, 5, 'Parfait, je vous prépare un lien avec la galerie complète et je reviens vers vous.'),
(23,44579, 18, 'Bonjour, j''ai vu votre annonce. Faites-vous des devis gratuits pour une rénovation de toiture ?'),
(18,44580, 23, 'Bonjour Madame. Oui, nos devis sont gratuits. Quand seriez-vous disponible pour une visite technique ?'),
(23,44581, 18, 'Jeudi prochain à 14h, cela vous convient ?'),
(18,44582, 23, 'C''est noté. Merci.'),
(36,44679, 40, 'Salut ! Toujours partante pour la randonnée de dimanche ?'),
(40,44680, 36, 'Oui ! Super motivée. La météo a l''air bonne en plus.'),
(36,44681, 40, 'Top. N''oublie pas l''eau !'),
(29,44789, 12, 'Bonjour, nous sommes "Gourmet & Fils". Nous cherchons un prestataire logistique pour nos livraisons en région parisienne.'),
(12,44790, 29, 'Bonjour, "Leclerc Services" peut en effet gérer cela. Pouvez-vous me donner une estimation des volumes mensuels ?'),
(29,44791, 12, 'Nous estimons environ 300 palettes/mois.'),
(49,44879, 22, 'Bonjour, j''ai une question concernant le chantier rue de la Paix. Pouvez-vous me dire quand la circulation sera rétablie ?'),
(22,44880, 49, 'Bonjour, selon le planning actuel, la réouverture est prévue pour vendredi soir. Sauf imprévu météo.'),
(49,44881, 22, 'Merci beaucoup pour votre réponse rapide.'),
(33,44979, 1, 'Bonjour, mon contrat habitation arrive à échéance. Pouvez-vous m''envoyer une proposition de renouvellement ? Mon ID client est 789A.'),
(1,44980, 33, 'Bonjour M. (ShadowHunter). Nous traitons votre demande et revenons vers vous sous 48h avec la proposition.');

/*==============================================================*/
/* Table : recherche (15 recherches)                            */
/*==============================================================*/

INSERT INTO recherche (idutilisateur, idville, iddatefinrecherche, iddepartement, idregion, iddatedebutrecherche,
paiementenligne, capaciteminimumvoyageur, prixminimum, prixmaximum, nombreminimumchambre, nombremaximumchambre) VALUES

(5, NULL, 33993, NULL, 1, 33979, true, 4, NULL, 3000, 2, NULL),
(18, 8, 34186, 06, 1, 34179, false, 2, NULL, 1200, 1, 2),
(40, NULL, NULL, 83, 1, NULL, False, 6, 1000, 4000, 3, NULL),
(22, NULL, 34089, NULL, 6, 34079, true, 1, NULL, 800, NULL, 1),
(3, NULL, NULL, NULL, NULL, NULL, false, 2, NULL, 1500, NULL, NULL),
(49, NULL, 34209, NULL, 11, 34179, false, NULL, NULL, NULL, NULL, NULL),
(1, NULL, 34004, NULL, NULL, 33997, false, NULL, NULL, NULL, 1, NULL),
(12, NULL, NULL, NULL, NULL, NULL, true, 4, 3000, NULL, 2, NULL),
(36, 42, 33987, 64, 12, 33980, true, NULL, 500, 2500, 2, 2),
(27, NULL, NULL, 33, 12, NULL, false, 2, NULL, NULL, 1, NULL),
(50, NULL, 34287, NULL, 8, 34280, false, 4, NULL, 2200, 2, NULL),
(9, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, 1000, NULL, NULL),
(14, NULL, NULL, NULL, 11, NULL, false, 6, NULL, NULL, 3, NULL),
(25, NULL, NULL, NULL, NULL, NULL, false, NULL, 500, 1500, NULL, NULL),
(33, 34, NULL, 34, 11, NULL, false, 1, NULL, 700, NULL, 1),
(44, NULL, 34001, NULL, NULL, 33994, false, 2, NULL, NULL, NULL, 3),
(7, NULL, NULL, 33, 12, NULL, true, NULL, NULL, NULL, 2, NULL),
(20, NULL, 34000, NULL, 6, 33979, false, NULL, NULL, 950, NULL, NULL),
(41, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, 700, 1, 1),
(2, NULL, 34009, NULL, 1, 33979, true, NULL, 4000, 8000, NULL, NULL);

/*============================================================================================================================================*/
/*============================================================================================================================================*/
/* INSERTIONS SEPTIEME NIVEAU                                                                                                                 */
/*============================================================================================================================================*/
/*============================================================================================================================================*/

/*==============================================================*/
/* Table : statutdemande (3 statuts de demande)                 */
/*==============================================================*/

INSERT INTO statutdemande (nomstatut) VALUES ('En attente');
INSERT INTO statutdemande (nomstatut) VALUES ('Validée');
INSERT INTO statutdemande (nomstatut) VALUES ('Refusée');

/*==============================================================*/
/* Table : reservation (104 reservations)                       */
/*==============================================================*/

INSERT INTO reservation(idannonce, iddatedebutreservation, iddatefinreservation, idutilisateur, nomclient, prenomclient, telephoneclient)
VALUES (
  1,
  (SELECT iddate FROM date WHERE date = CURRENT_DATE + INTERVAL '3 days'),
  (SELECT iddate FROM date WHERE date = CURRENT_DATE + INTERVAL '10 days'),
  1,
  'Janvier',
  'Sarah',
  '0695638456'
);

INSERT INTO reservation(idannonce,iddatedebutreservation,iddatefinreservation,idutilisateur,nomclient,prenomclient,telephoneclient) VALUES

(1,44160,44164,1,'Janvier','Sarah','0695638456'),
(1,44175,44179,2,'Duval','Simon','0717374228'),
(1,44195,44199,3,'Dam','Rachel','0729484225'),
(1,44215,44219,4,'Borde','Jeanne','0705434475'),
(2,44618,44621,5,'Lemaire','Caroline','0689771334'),
(2,44633,44636,6,'Geelen','Alexis','0639185787'),
(2,44653,44656,7,'Brisbois','Alexandre','0722052574'),
(2,44673,44676,8,'Holt','Olivier','0622562347'),
(3,44444,44445,9,'Archambault','Kim','0703877291'),
(3,44459,44460,10,'Koopman','Dorian','0797861221'),
(3,44479,44480,11,'Tremblay','Jessica','0753618415'),
(3,44499,44500,12,'Lane','Leila','0623466333'),
(4,43342,43345,13,'Monet','Tanguy','0698143673'),
(4,43357,43360,14,'Chaput','Jerome','0622505865'),
(4,43377,43380,15,'Van Aalsburg','Ali','0608239111'),
(4,43397,43400,16,'Lachapelle','Emile','0745648808'),
(5,45435,45437,17,'Maes','Océane','0761917131'),
(5,45450,45452,18,'Lemaire','Valerie','0741448125'),
(5,45470,45472,19,'Jonker','Valentin','0648633468'),
(5,45490,45492,20,'Maes','Hugo','0710581186'),
(6,45844,45845,21,'Berg','Helene','0746100284'),
(6,45859,45860,22,'Travers','Gauthier','0771141213'),
(6,45879,45880,23,'De Witte','Grégoire','0667232663'),
(6,45899,45900,24,'Garcon','Rachel','0652211742'),
(7,45840,45843,25,'Rademaker','Quentin','0772562261'),
(7,45855,45858,1,'Janvier','Sarah','0695638456'),
(7,45875,45878,2,'Duval','Simon','0717374228'),
(7,45895,45898,3,'Dam','Rachel','0729484225'),
(8,44870,44873,4,'Borde','Jeanne','0705434475'),
(8,44885,44888,5,'Lemaire','Caroline','0689771334'),
(8,44905,44908,6,'Geelen','Alexis','0639185787'),
(8,44925,44928,7,'Brisbois','Alexandre','0722052574'),
(9,43988,43991,8,'Holt','Olivier','0622562347'),
(9,44003,44006,9,'Archambault','Kim','0703877291'),
(9,44023,44026,10,'Koopman','Dorian','0797861221'),
(9,44043,44046,11,'Tremblay','Jessica','0753618415'),
(10,44082,44085,12,'Lane','Leila','0623466333'),
(10,44097,44100,13,'Monet','Tanguy','0698143673'),
(10,44117,44120,14,'Chaput','Jerome','0622505865'),
(10,44137,44140,15,'Van Aalsburg','Ali','0608239111'),
(11,44818,44822,16,'Lachapelle','Emile','0745648808'),
(11,44833,44837,17,'Maes','Océane','0761917131'),
(11,44853,44857,18,'Lemaire','Valerie','0741448125'),
(11,44873,44877,19,'Jonker','Valentin','0648633468'),
(12,44961,44963,20,'Maes','Hugo','0710581186'),
(12,44976,44978,21,'Berg','Helene','0746100284'),
(12,44996,44998,22,'Travers','Gauthier','0771141213'),
(12,45016,45018,23,'De Witte','Grégoire','0667232663'),
(13,44088,44089,24,'Garcon','Rachel','0652211742'),
(13,44103,44104,25,'Rademaker','Quentin','0772562261'),
(13,44123,44124,1,'Janvier','Sarah','0695638456'),
(13,44143,44144,2,'Duval','Simon','0717374228'),
(14,44649,44652,3,'Dam','Rachel','0729484225'),
(14,44664,44667,4,'Borde','Jeanne','0705434475'),
(14,44684,44687,5,'Lemaire','Caroline','0689771334'),
(14,44704,44707,6,'Geelen','Alexis','0639185787'),
(15,45427,45429,7,'Brisbois','Alexandre','0722052574'),
(15,45442,45444,8,'Holt','Olivier','0622562347'),
(15,45462,45464,9,'Archambault','Kim','0703877291'),
(15,45482,45484,10,'Koopman','Dorian','0797861221'),
(16,45781,45784,11,'Tremblay','Jessica','0753618415'),
(16,45796,45799,12,'Lane','Leila','0623466333'),
(16,45816,45819,13,'Monet','Tanguy','0698143673'),
(16,45836,45839,14,'Chaput','Jerome','0622505865'),
(17,43374,43378,15,'Van Aalsburg','Ali','0608239111'),
(17,43389,43393,16,'Lachapelle','Emile','0745648808'),
(17,43409,43413,17,'Maes','Océane','0761917131'),
(17,43429,43433,18,'Lemaire','Valerie','0741448125'),
(18,45856,45859,19,'Jonker','Valentin','0648633468'),
(18,45871,45874,20,'Maes','Hugo','0710581186'),
(18,45891,45894,21,'Berg','Helene','0746100284'),
(18,45911,45914,22,'Travers','Gauthier','0771141213'),
(19,45295,45297,23,'De Witte','Grégoire','0667232663'),
(19,45310,45312,24,'Garcon','Rachel','0652211742'),
(19,45330,45332,25,'Rademaker','Quentin','0772562261'),
(19,45350,45352,1,'Janvier','Sarah','0695638456'),
(20,45659,45660,2,'Duval','Simon','0717374228'),
(20,45674,45675,3,'Dam','Rachel','0729484225'),
(20,45694,45695,4,'Borde','Jeanne','0705434475'),
(20,45714,45715,5,'Lemaire','Caroline','0689771334'),
(21,45706,45708,6,'Geelen','Alexis','0639185787'),
(21,45721,45723,7,'Brisbois','Alexandre','0722052574'),
(21,45741,45743,8,'Holt','Olivier','0622562347'),
(21,45761,45763,9,'Archambault','Kim','0703877291'),
(22,44930,44931,10,'Koopman','Dorian','0797861221'),
(22,44945,44946,11,'Tremblay','Jessica','0753618415'),
(22,44965,44966,12,'Lane','Leila','0623466333'),
(22,44985,44986,13,'Monet','Tanguy','0698143673'),
(23,43991,43993,14,'Chaput','Jerome','0622505865'),
(23,44006,44008,15,'Van Aalsburg','Ali','0608239111'),
(23,44026,44028,16,'Lachapelle','Emile','0745648808'),
(23,44046,44048,17,'Maes','Océane','0761917131'),
(24,43830,43831,18,'Lemaire','Valerie','0741448125'),
(24,43845,43846,19,'Jonker','Valentin','0648633468'),
(24,43865,43866,20,'Maes','Hugo','0710581186'),
(24,43885,43886,21,'Berg','Helene','0746100284'),
(25,44654,44658,22,'Travers','Gauthier','0771141213'),
(25,44669,44673,23,'De Witte','Grégoire','0667232663'),
(25,44689,44693,24,'Garcon','Rachel','0652211742'),
(25,44709,44713,25,'Rademaker','Quentin','0772562261'),
(3,46035,46038,40,'Berger','Claire','0678877669'),
(10,46034,46038,1,'Test Reservation','En Cours','0784685034');

/*==============================================================*/
/* Table : avis (80 avis)                                       */
/*==============================================================*/

INSERT INTO avis(idannonce, iddate, idutilisateur, texteavis, nombreetoiles) VALUES

(1,44164,1,'Séjour parfait, logement propre et bien situé. Tout était conforme aux photos.',5.0),
(1,44179,2,'Propriétaire très sympathique et disponible. Je recommande sans hésiter.',5.0),
(1,44199,3,'Très bel appartement, idéalement placé pour visiter la région. Nous reviendrons.',5.0),
(2,44621,5,'Logement correct pour le prix. Quelques petits détails à améliorer mais dans l''ensemble correct.',3.2),
(2,44636,6,'Bien situé mais un peu bruyant le soir. Le logement était propre malgré tout.',3.0),
(2,44656,7,'Nuit blanche à cause du bruit de la route. Pas top pour se reposer.',2.2),
(3,44445,9,'Propriétaire injoignable à l''arrivée, heureusement que nous avions le code.',2.0),
(3,44460,10,'Logement très propre, tout neuf. Un vrai plaisir de séjourner ici.',5.0),
(3,44480,11,'Superbe semaine dans ce logement charmant. Le lit est très confortable.',5.0),
(4,43345,13,'La cuisine est très bien équipée, c''est un vrai plus. Merci au propriétaire.',5.0),
(4,43360,14,'Un peu déçu par la propreté, les sols n''étaient pas impeccables.',2.0),
(4,43380,15,'L''appartement est plus petit que sur les photos, mais correct pour deux personnes.',3.0),
(5,45437,17,'Excellent rapport qualité-prix. Le logement est simple mais fonctionnel et propre.',4.0),
(5,45452,18,'Vue imprenable depuis le balcon. Le réveil en valait la peine.',5.0),
(5,45472,19,'Communication excellente avec le propriétaire, très réactif et serviable.',5.0),
(6,45845,21,'Le quartier est calme et résidentiel, parfait pour une famille avec enfants.',5.0),
(6,45860,22,'Logement un peu vieillot, mais globalement propre. Ça fait le job pour une courte durée.',3.0),
(6,45880,23,'Pas de Wi-Fi, ce qui était un peu contraignant. Le reste était correct.',3.0),
(7,45843,25,'Très bel endroit, le jardin est un vrai bonus. Les enfants ont adoré.',5.0),
(7,45858,1,'Propreté irréprochable, on sent que le propriétaire entretient son bien.',5.0),
(7,45878,2,'Séjour magnifique. La décoration est soignée et l''ambiance très agréable.',5.0),
(8,44873,4,'Le canapé-lit est très inconfortable, nuits difficiles en perspective.',2.4),
(8,44888,5,'L''annonce est fidèle, aucune mauvaise surprise. Logement propre et fonctionnel.',4.0),
(8,44908,6,'Très bien placé, à deux pas de la plage. On a tout fait à pied.',5.0),
(9,43991,8,'Le logement manquait un peu de rangement pour nos affaires.',3.0),
(9,44006,9,'Accueil un peu froid, mais le logement correspondait à la description.',3.0),
(9,44026,10,'Douches chaudes et pression de l''eau parfaite. C''était un vrai bonheur.',5.0),
(10,44085,12,'Literie de qualité, nous avons très bien dormi. Je recommande.',5.0),
(10,44100,13,'Expérience correcte. Le logement est basique mais propre.',3.0),
(10,44120,14,'Le parking est un vrai plus en centre-ville. Très pratique.',5.0),
(11,44822,16,'Logement très lumineux et agréable à vivre. On s''y sentait bien.',5.0),
(11,44837,17,'Un peu cher pour ce qui est offert, surtout en basse saison.',2.0),
(11,44857,18,'Le linge de maison fourni était de très bonne qualité.',4.8),
(12,44963,20,'Séjour décevant, l''appartement sentait l''humidité à notre arrivée.',1.0),
(12,44978,21,'Le chauffage était un peu faible pour la saison, on a eu un peu froid.',3.0),
(12,44998,22,'Propriétaire qui nous a donné de bonnes adresses, merci pour les conseils.',5.0),
(13,44089,24,'Logement impeccable, rien à redire. Un excellent moment passé.',5.0),
(13,44104,25,'Les voisins étaient un peu bruyants, mais ce n''est pas la faute du propriétaire.',3.0),
(13,44124,1,'Très facile d''accès avec les codes donnés par le propriétaire.',4.0),
(14,44652,3,'Pas de plaintes particulières, un séjour simple et efficace.',4.0),
(14,44667,4,'La literie sentait la fumée, ce qui était très désagréable.',1.0),
(14,44687,5,'Superbe piscine, nous en avons profité un maximum. Enfants ravis.',5.0),
(15,45429,7,'Logement conforme à l''annonce, propre et bien agencé.',4.0),
(15,45444,8,'Nous avons passé un excellent séjour. Le cadre est vraiment reposant.',5.0),
(15,45464,9,'Appartement bien situé mais nécessite quelques travaux de peinture.',3.0),
(16,45784,11,'La douche est un peu petite, mais le reste est très bien.',3.6),
(16,45799,12,'Accueil très chaleureux, le propriétaire a su nous mettre à l''aise.',5.0),
(16,45819,13,'Le logement est parfait pour un couple. Coquet et fonctionnel.',5.0),
(17,43378,15,'Très bon séjour, la proximité du commerce est un vrai plus.',4.0),
(17,43393,16,'Le ménage avait été fait à la va-vite, traces de poussière un peu partout.',2.0),
(17,43413,17,'Communication fluide et rapide avant et pendant le séjour.',5.0),
(18,45859,19,'Nous avons été très bien accueillis. Le logement était parfait.',5.0),
(18,45874,20,'L''équipement de la cuisine est minimaliste, on a dû acheter des choses.',3.1),
(18,45894,21,'Logement très propre et bien entretenu. Je recommande vivement.',5.0),
(19,45297,23,'Un peu cher pour la surface proposée, mais bien situé.',3.0),
(19,45312,24,'Le lit était incroyablement confortable. Nous avons bien récupéré.',5.0),
(19,45332,25,'Très bel appartement, moderne et tout équipé. On a adoré.',5.0),
(20,45660,2,'Le quartier est un peu loin du centre, il faut une voiture.',2.0),
(20,45675,3,'Rien à dire, tout était parfait. Un grand merci au propriétaire.',5.0),
(20,45695,4,'Séjour sympa, logement correct pour une courte escapade.',4.0),
(21,45708,6,'Les murs sont un peu fins, on entendait les voisins.',3.0),
(21,45723,7,'Le sèche-cheveux ne fonctionnait pas, dommage.',2.0),
(21,45743,8,'Logement calme et reposant, exactement ce qu''il nous fallait.',5.0),
(21,45763,9,'Superbe terrasse pour les repas du soir. C''était le top.',5.0),
(22,44931,10,'La description est précise, on a trouvé ce qui était annoncé.',4.5),
(22,44946,11,'L''appartement est un peu sombre, manque de lumière naturelle.',3.5),
(22,44966,12,'Propre et bien situé, un très bon rapport qualité-prix.',4.0),
(22,44986,13,'Nous avons eu un souci de plomberie, vite résolu par le propriétaire.',4.0),
(23,43993,14,'Logement très fonctionnel, tout est pensé pour que l''on soit à l''aise.',5.0),
(23,44008,15,'Un peu de bruit le matin à cause des poubelles, mais correct.',3.0),
(23,44028,16,'Le cadre est magnifique, entouré par la nature. On a déconnecté.',5.0),
(23,44048,17,'Le Wi-Fi était très instable, difficile de travailler un peu.',2.0),
(24,43831,18,'Excellente surprise, le logement est encore mieux qu''en photo.',5.0),
(24,43846,19,'Très bien, je recommande. Propriétaire sérieux et arrangeant.',5.0),
(24,43866,20,'Séjour correct, pas de surprise majeure ni de coup de cœur.',3.0),
(24,43886,21,'L''appartement manquait d''un peu de chaleur dans la décoration.',3.7),
(25,44658,22,'Très propre, on a apprécié le petit-déjeuner offert à l''arrivée.',5.0),
(25,44673,23,'Le logement est bien, mais le matelas mériterait d''être changé.',3.8),
(25,44693,24,'Très bel emplacement, au calme et avec une jolie vue.',5.0);

/*==============================================================*/
/* Table : photo (100 photos pour les annonces)                 */
/*==============================================================*/

INSERT INTO photo (idannonce, idincident, lienphoto) VALUES

-- 1/2. Photos annonce
(1, null,   'https://cdn.pixabay.com/photo/2016/11/18/17/20/living-room-1835923_1280.jpg'),
(1, null,   'https://cdn.pixabay.com/photo/2017/09/09/18/25/living-room-2732939_1280.jpg'),
(2, null,   'https://cdn.pixabay.com/photo/2015/10/20/18/57/furniture-998265_1280.jpg'),
(2, null,   'https://cdn.pixabay.com/photo/2017/01/07/17/48/interior-1961070_1280.jpg'),
(3, null,   'https://cdn.pixabay.com/photo/2017/03/28/12/10/chairs-2181947_1280.jpg'),
(4, null,   'https://cdn.pixabay.com/photo/2014/07/10/17/18/large-home-389271_1280.jpg'),
(5, null,   'https://cdn.pixabay.com/photo/2017/07/09/03/19/home-2486092_1280.jpg'),
(6, null,   'https://cdn.pixabay.com/photo/2022/03/30/14/55/holiday-home-7101309_1280.jpg'),
(7, null,   'https://cdn.pixabay.com/photo/2022/10/03/13/16/houses-7495861_1280.jpg'),
(8, null,   'https://cdn.pixabay.com/photo/2013/08/30/12/56/holiday-house-177401_1280.jpg'),
(9, null,   'https://cdn.pixabay.com/photo/2015/04/05/00/10/apartment-707239_1280.jpg'),
(10, null,  'https://cdn.pixabay.com/photo/2016/11/28/11/52/concrete-1864808_1280.jpg'),
(11, null,  'https://cdn.pixabay.com/photo/2017/06/12/15/08/canal-2395818_1280.jpg'),
(12, null,  'https://cdn.pixabay.com/photo/2017/06/12/15/10/street-2395821_1280.jpg'),
(13, null,  'https://cdn.pixabay.com/photo/2020/01/04/20/27/holiday-4741595_1280.jpg'),
(14, null,  'https://cdn.pixabay.com/photo/2014/12/11/14/09/alsace-564249_1280.jpg'),
(15, null,  'https://cdn.pixabay.com/photo/2020/07/17/17/17/building-5414821_1280.jpg'),
(16, null,  'https://cdn.pixabay.com/photo/2022/07/10/19/30/house-7313645_1280.jpg'),
(17, null,  'https://cdn.pixabay.com/photo/2016/11/30/08/48/bedroom-1872196_1280.jpg'),
(18, null,  'https://cdn.pixabay.com/photo/2022/11/22/10/37/house-7609267_1280.jpg'),
(19, null,  'https://cdn.pixabay.com/photo/2017/08/02/01/01/living-room-2569325_1280.jpg'),
(20, null,  'https://cdn.pixabay.com/photo/2017/08/27/10/16/interior-2685521_1280.jpg'),
(21, null,  'https://cdn.pixabay.com/photo/2024/12/13/14/45/real-estate-9265386_1280.jpg'),
(22, null,  'https://cdn.pixabay.com/photo/2017/03/28/12/13/chairs-2181968_1280.jpg'),
(23, null,  'https://cdn.pixabay.com/photo/2017/03/19/01/43/living-room-2155376_1280.jpg'),
(24, null,  'https://cdn.pixabay.com/photo/2020/09/14/09/47/living-room-5570508_1280.jpg'),
(25, null,  'https://cdn.pixabay.com/photo/2018/01/26/08/15/dining-room-3108037_1280.jpg'),
(26, null,  'https://cdn.pixabay.com/photo/2012/07/25/13/48/luggage-52831_1280.jpg'),
(27, null,  'https://cdn.pixabay.com/photo/2019/03/05/22/58/living-room-4037295_1280.jpg'),
(28, null,  'https://cdn.pixabay.com/photo/2022/01/08/08/07/home-6923504_1280.jpg'),
(29, null,  'https://cdn.pixabay.com/photo/2014/07/31/21/41/apartment-406901_1280.jpg'),
(30, null,  'https://cdn.pixabay.com/photo/2022/04/09/13/35/living-room-7121425_1280.jpg'),
(31, null,  'https://cdn.pixabay.com/photo/2014/11/27/20/14/waiting-room-548136_1280.jpg'),
(32, null,  'https://cdn.pixabay.com/photo/2021/01/17/15/41/home-5925502_1280.jpg'),
(33, null,  'https://images.unsplash.com/photo-1507089947368-19c1da9775ae'),
(34, null,  'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e'),
(35, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/c3/26/07/c326071dece8dd007bbea7f3645bdcf5dee3732f.jpg?rule=ad-large'),
(36, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/c9/ef/80/c9ef8013aa29545537e28268cbc515c37756f672.jpg?rule=classified-1200x800-webp'),
(37, null,  'https://images.unsplash.com/photo-1493809842364-78817add7ffb'),
(38, null,  'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2'),
(39, null,  'https://images.unsplash.com/photo-1524758631624-e2822e304c36'),
(40, null,  'https://images.unsplash.com/photo-1523217582562-09d0def993a6'),
(41, null,  'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85'),
(42, null,  'https://images.unsplash.com/photo-1502005097973-6a7082348e28'),
(43, null,  'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg'),
(44, null,  'https://images.pexels.com/photos/271743/pexels-photo-271743.jpeg'),
(45, null,  'https://images.pexels.com/photos/259962/pexels-photo-259962.jpeg'),
(46, null,  'https://images.pexels.com/photos/262405/pexels-photo-262405.jpeg'),
(47, null,  'https://images.pexels.com/photos/2102587/pexels-photo-2102587.jpeg'),
(48, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/49/bf/94/49bf94d999304457427abfb3959f5ccb7fabe168.jpg?rule=ad-large'),
(49, null,  'https://images.pexels.com/photos/271816/pexels-photo-271816.jpeg'),
(50, null,  'https://images.pexels.com/photos/534151/pexels-photo-534151.jpeg'),
(51, null,  'https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg'),
(52, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/0d/48/2a/0d482abdf89b23eeea57bc0ee48f0c87715fcdbb.jpg?rule=ad-large'),
(53, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/9e/cf/cf/9ecfcf4d058cedcabf03b744124bc86707089a1e.jpg?rule=classified-1200x800-webp'),
(54, null,  'https://images.unsplash.com/photo-1501183638710-841dd1904471'),
(55, null,  'https://images.unsplash.com/photo-1554995207-c18c203602cb'),
(56, null,  'https://images.unsplash.com/photo-1505691938895-1758d7feb511'),
(57, null,  'https://images.unsplash.com/photo-1538688525198-9b88f6f53126'),
(58, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/2e/49/05/2e4905d8d9a61d5973b9cdb3ff143cf6da270bf8.jpg?rule=classified-1200x800-webp'),
(59, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/3c/cc/92/3ccc9218a31c4e07ccb011a81d2f656fd4e97ce0.jpg?rule=classified-1200x800-webp'),
(60, null,  'https://images.unsplash.com/photo-1493809842364-78817add7ffb?ixid=Mnwx'),
(61, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/92/9a/04/929a04e3400dcece4a395e3a93827a7ca1399cac.jpg?rule=classified-1200x800-webp'),
(62, null,  'https://images.unsplash.com/photo-1484154218962-a197022b5858'),
(63, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/1d/47/5a/1d475a0b21891a16cdba5537dddae5e3d2799503.jpg?rule=classified-1200x800-webp'),
(64, null,  'https://images.unsplash.com/photo-1540518614846-7eded433c457'),
(65, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/a9/67/c0/a967c079aad203e798d19cfb8bd830c484437f45.jpg?rule=ad-large'),
(66, null,  'https://images.pexels.com/photos/534172/pexels-photo-534172.jpeg'),
(67, null,  'https://images.pexels.com/photos/271805/pexels-photo-271805.jpeg'),
(68, null,  'https://images.pexels.com/photos/1571461/pexels-photo-1571461.jpeg'),
(69, null,  'https://images.pexels.com/photos/1643384/pexels-photo-1643384.jpeg'),
(70, null,  'https://images.pexels.com/photos/373548/pexels-photo-373548.jpeg'),
(71, null,  'https://images.pexels.com/photos/259580/pexels-photo-259580.jpeg'),
(72, null,  'https://images.pexels.com/photos/1571467/pexels-photo-1571467.jpeg'),
(73, null,  'https://images.pexels.com/photos/1125135/pexels-photo-1125135.jpeg'),
(74, null,  'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg'),
(75, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/e6/c6/4d/e6c64deb72ae9928e1263b205479385b67e6e4d2.jpg?rule=ad-large'),
(76, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/7c/e1/8e/7ce18e7e14f2ca141de4f287c060ce38b8176b9a.jpg?rule=ad-large'),
(77, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/6f/21/6a/6f216aed4991e14b9971d7c8b9d96b06afdc6f7e.jpg?rule=ad-large'),
(78, null,  'https://img.leboncoin.fr/api/v1/lbcpb1/images/d5/1d/e9/d51de93814031f6c76a0f1b3304e14fe96416da2.jpg?rule=ad-large'),
(79, null,  'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg'),
(80, null,  'https://images.pexels.com/photos/276583/pexels-photo-276583.jpeg'),
(81, null,  'https://placehold.co/1200x800?text=Annonce+81'),
(82, null,  'https://placehold.co/1200x800?text=Annonce+82'),
(83, null,  'https://placehold.co/1200x800?text=Annonce+83'),
(84, null,  'https://placehold.co/1200x800?text=Annonce+84'),
(85, null,  'https://placehold.co/1200x800?text=Annonce+85'),
(86, null,  'https://placehold.co/1200x800?text=Annonce+86'),
(87, null,  'https://placehold.co/1200x800?text=Annonce+87'),
(88, null,  'https://placehold.co/1200x800?text=Annonce+88'),
(89, null,  'https://placehold.co/1200x800?text=Annonce+89'),
(90, null,  'https://placehold.co/1200x800?text=Annonce+90'),
(91, null,  'https://placehold.co/1200x800?text=Annonce+91'),
(92, null,  'https://placehold.co/1200x800?text=Annonce+92'),
(93, null,  'https://placehold.co/1200x800?text=Annonce+93'),
(94, null,  'https://placehold.co/1200x800?text=Annonce+94'),
(95, null,  'https://placehold.co/1200x800?text=Annonce+95'),
(96, null,  'https://placehold.co/1200x800?text=Annonce+96'),
(97, null,  'https://placehold.co/1200x800?text=Annonce+97'),
(98, null,  'https://placehold.co/1200x800?text=Annonce+98'),
(99, null,  'https://placehold.co/1200x800?text=Annonce+99'),
(100, null, 'https://placehold.co/1200x800?text=Annonce+100'),
(101, null, 'https://placehold.co/1200x800?text=Annonce+101');

/*==============================================================*/
/* Table : ressembler (1931 lignes)                             */
/*==============================================================*/

INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (1,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (2,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (3,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (4,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (5,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (6,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (7,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (8,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (9,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (10,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (11,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (12,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (13,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (14,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (15,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (16,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (17,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (18,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (19,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (20,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (21,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (22,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (23,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (24,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (25,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (26,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (27,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (28,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (29,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (30,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (31,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (32,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (33,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (34,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (35,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (36,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (37,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (38,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (39,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (40,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (41,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (42,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (43,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (44,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (45,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (46,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (47,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (48,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (49,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (50,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (51,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (52,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (53,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (54,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (55,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (56,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (57,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (58,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (59,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (60,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (61,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (62,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (63,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (64,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (65,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (66,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (67,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (68,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (69,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (70,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,50);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (71,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (72,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (73,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,49);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (74,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,6);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,77);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (75,80);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,42);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,51);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,67);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (76,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,2);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,34);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,39);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,46);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,47);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,48);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,78);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (77,79);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,4);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,15);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,32);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,43);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (78,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,7);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,10);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,11);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,13);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,23);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,27);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,37);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,44);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,61);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,65);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (79,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,1);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,3);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,5);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,8);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,9);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,38);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,40);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,56);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,59);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,75);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,76);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (80,77);
-- Annonces "à verifier"
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (81,22);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (81,60);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (82,28);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (82,63);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (83,19);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (83,54);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (84,35);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (84,71);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (85,14);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (85,52);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (86,31);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (86,64);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (87,18);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (87,57);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (88,26);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (88,69);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (89,33);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (89,74);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (90,12);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (90,41);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (91,45);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (91,70);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (92,16);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (92,55);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (93,29);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (93,68);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (94,24);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (94,62);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (95,20);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (95,53);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (96,36);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (96,72);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (97,17);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (97,58);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (98,25);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (98,66);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (99,30);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (99,73);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (100,21);
INSERT INTO ressembler(idannonce_a,idannonce_b) VALUES (100,65);

/*==============================================================*/
/* Table : cibler (38 lignes)                                   */
/*==============================================================*/

INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (1,2);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (1,5);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (1,9);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (2,6);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (2,8);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (3,2);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (3,8);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (4,5);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (4,9);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (6,1);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (6,2);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (6,6);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (6,7);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (7,2);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (8,1);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (8,4);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (8,8);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (9,4);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (9,8);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (10,5);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (10,6);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (10,7);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (10,8);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (11,4);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (12,7);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (13,1);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (13,4);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (14,7);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (14,8);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (15,2);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (17,7);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (18,4);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (18,7);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (19,6);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (19,7);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (20,4);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (20,5);
INSERT INTO cibler(idrecherche,idtypehebergement) VALUES (20,8);

/*==============================================================*/
/* Table : favoriser (1162 lignes)                              */
/*==============================================================*/

INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (1,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (2,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (3,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (3,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (3,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (3,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (3,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (3,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (3,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (3,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (3,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (3,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (3,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (3,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (4,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (5,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (6,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (7,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (8,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (9,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (10,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (11,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (12,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (13,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (14,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (15,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (16,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (17,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (18,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (18,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (18,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (18,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (18,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (18,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (18,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (18,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (18,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (19,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (20,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (21,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (22,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (22,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (22,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (22,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (22,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (22,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (22,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (22,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (22,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (22,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (23,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (24,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (25,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (25,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (25,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (25,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (25,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (25,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (25,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (25,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (25,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (25,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (25,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (26,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (27,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (28,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (29,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (29,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (29,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (29,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (29,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (29,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (29,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (29,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (29,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (29,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (29,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (29,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (30,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (30,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (30,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (30,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (30,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (30,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (30,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (30,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (30,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (30,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (30,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (30,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (31,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (32,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (32,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (32,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (32,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (32,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (32,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (32,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (32,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (32,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (32,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (32,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (33,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (34,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (35,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (36,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (37,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (38,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (38,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (38,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (38,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (38,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (38,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (38,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (38,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (38,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (38,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (38,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (39,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (40,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (41,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (42,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (43,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (44,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (45,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (46,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (46,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (46,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (46,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (46,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (46,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (47,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (48,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (49,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (49,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (49,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (49,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (49,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (49,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (49,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (49,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (49,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (49,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (49,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (50,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (51,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (52,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (53,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (53,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (53,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (53,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (53,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (53,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (53,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (53,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (53,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (53,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (53,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (53,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (54,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (55,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (56,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (57,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (57,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (57,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (57,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (57,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (57,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (57,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (57,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (57,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (57,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (57,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (57,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (58,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (59,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (59,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (59,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (59,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (59,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (59,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (59,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (59,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (59,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (59,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (59,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (60,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (61,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (61,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (61,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (61,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (61,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (61,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (61,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (61,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (62,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (63,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (64,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (64,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (64,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (64,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (64,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (64,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (64,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (64,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (64,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (64,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (64,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (65,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (66,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (67,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (67,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (67,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (67,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (67,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (67,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (67,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (67,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (67,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (67,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (68,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (68,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (68,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (68,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (68,16);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (68,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (68,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (68,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (68,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (68,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (68,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (68,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,15);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,48);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (69,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,12);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,14);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (70,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,18);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (71,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,3);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (72,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (73,4);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (73,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (73,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (73,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (73,21);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (73,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (73,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (73,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (73,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (73,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (73,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (73,46);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (74,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (74,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (74,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (74,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (74,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (74,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (74,44);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (74,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (74,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,41);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (75,50);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,19);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,20);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,27);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,35);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (76,45);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,5);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,6);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,33);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,34);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,36);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,38);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (77,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,10);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,22);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,23);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,31);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,39);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,40);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,42);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (78,47);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (79,1);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (79,7);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (79,9);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (79,17);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (79,25);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (79,28);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (79,29);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (79,32);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (79,37);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (79,43);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (79,49);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (80,2);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (80,8);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (80,11);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (80,13);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (80,24);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (80,26);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (80,30);
INSERT INTO "AnnonceUtilisateur"("Idannonce", "Idutilisateur") VALUES (80,47);

/*==============================================================*/
/* Table : proposer (1729 lignes)                               */
/*==============================================================*/

INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (9,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (9,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (9,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (9,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (9,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (9,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (9,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (9,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (9,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (7,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (9,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (1,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (4,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (10,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (8,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (3,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (5,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (9,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (12,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (6,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (11,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (2,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (15,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (19,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (21,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (17,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (13,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (22,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (24,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (25,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (14,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (18,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (16,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (20,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (23,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (26,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (27,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,1);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,2);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,3);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,4);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,5);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,6);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,7);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,8);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,9);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,10);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,11);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,12);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,13);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,14);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,15);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,16);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,17);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,18);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,19);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,20);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,21);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,22);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,23);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,24);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,25);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,26);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,27);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,28);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,29);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,30);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,31);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,32);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,33);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,34);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,35);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,36);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,37);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,38);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,39);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,40);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,41);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,42);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,43);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,44);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,45);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,46);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,47);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,48);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,49);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,50);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,51);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,52);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,53);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,54);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,55);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,56);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,57);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,58);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,59);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,60);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,61);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,62);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,63);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,64);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,65);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,66);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,67);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,68);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,69);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,70);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,71);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,72);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,73);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,74);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,75);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (48,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,76);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (34,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,77);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (31,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (36,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (50,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,78);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (28,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (29,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (30,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (35,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (39,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (41,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (43,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (44,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (47,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (52,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (55,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (56,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,79);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (32,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (33,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (37,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (38,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (40,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (42,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (45,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (46,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (49,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (51,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (53,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (54,80);
INSERT INTO "AnnonceCommodite"("Idcommodite", "Idannonce") VALUES (57,80);

/*==============================================================*/
/* Table : filtrer (315 lignes)                                 */
/*==============================================================*/

INSERT INTO filtrer(idcommodite, idrecherche) VALUES (11,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (8,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (1,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (12,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (5,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (4,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (4,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (12,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (10,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (1,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (11,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (11,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (9,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (6,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (12,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (8,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (11,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (6,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (4,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (1,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (12,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (7,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (6,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (6,10);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (9,11);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (8,11);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (3,11);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (10,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (8,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (7,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (8,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (2,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (1,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (10,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (8,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (3,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (1,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (5,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (12,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (11,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (8,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (12,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (4,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (12,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (8,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (5,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (4,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (16,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (23,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (24,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (27,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (16,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (18,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (19,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (17,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (22,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (20,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (23,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (26,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (14,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (21,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (26,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (20,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (23,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (16,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (18,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (20,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (21,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (14,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (26,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (27,10);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (16,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (26,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (14,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (19,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (22,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (27,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (15,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (17,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (23,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (13,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (15,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (16,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (19,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (24,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (20,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (17,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (20,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (25,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (14,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (16,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (21,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (24,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (26,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (14,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (20,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (22,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (24,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (14,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (24,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (51,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (48,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (44,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (43,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (42,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (41,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (39,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (35,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (34,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (30,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (29,1);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (57,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (52,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (47,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (46,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (41,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (39,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (35,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (31,2);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (57,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (56,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (55,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (54,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (52,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (51,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (49,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (44,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (43,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (40,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (34,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (32,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (28,3);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (57,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (49,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (44,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (42,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (41,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (40,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (39,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (38,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (36,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (35,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (29,4);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (57,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (56,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (55,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (52,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (49,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (47,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (45,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (43,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (42,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (40,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (37,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (34,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (32,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (29,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (28,5);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (53,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (52,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (51,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (43,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (40,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (39,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (34,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (31,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (28,6);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (55,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (53,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (52,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (51,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (41,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (39,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (38,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (32,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (31,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (30,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (29,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (28,7);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (57,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (55,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (53,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (44,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (41,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (38,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (36,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (34,8);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (57,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (56,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (48,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (47,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (46,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (37,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (36,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (34,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (32,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (31,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (29,9);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (57,10);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (56,10);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (54,10);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,10);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (49,10);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (48,10);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (40,10);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (39,10);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (31,10);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (55,11);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (53,11);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,11);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (49,11);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (38,11);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (37,11);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (31,11);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (30,11);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (54,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (53,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (51,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (48,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (47,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (44,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (43,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (42,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (39,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (38,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (34,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (33,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (29,12);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (57,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (56,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (54,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (46,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (45,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (39,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (35,13);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (56,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (55,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (51,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (49,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (48,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (47,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (46,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (44,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (40,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (39,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (34,14);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (57,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (56,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (54,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (49,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (47,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (46,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (41,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (30,15);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (54,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (53,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (52,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (47,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (44,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (43,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (40,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (38,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (37,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (34,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (31,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (29,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (28,16);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (55,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (46,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (42,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (40,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (39,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (36,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (34,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (33,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (31,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (30,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (28,17);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (54,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (51,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (48,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (45,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (30,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (28,18);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (53,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (51,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (50,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (48,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (42,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (41,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (35,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (29,19);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (57,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (56,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (55,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (46,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (43,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (42,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (40,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (39,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (35,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (34,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (33,20);
INSERT INTO filtrer(idcommodite, idrecherche) VALUES (30,20);

/*============================================================================================================================================*/
/*============================================================================================================================================*/
/* INSERTIONS HUITIEME NIVEAU                                                                                                                 */
/*============================================================================================================================================*/
/*============================================================================================================================================*/

/*==============================================================*/
/* Table : relier (162235 lignes)                               */
/*==============================================================*/

INSERT INTO relier (idannonce, iddate, estdisponible)
SELECT 
    a.idannonce,
    d.iddate,
    TRUE
FROM annonce a
JOIN date d
  ON d.iddate >= a.iddate
ORDER BY a.idannonce, d.iddate;

UPDATE relier r
SET estdisponible = FALSE
FROM reservation res
WHERE r.idannonce = res.idannonce
  AND r.iddate BETWEEN res.iddatedebutreservation AND res.iddatefinreservation;

/*==============================================================*/
/* Table : inclure (207 lignes)                                 */
/*==============================================================*/

INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (1,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (1,2,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (1,4,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (2,1,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (3,3,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (4,1,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (4,4,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (5,1,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (5,2,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (5,4,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (6,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (6,3,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (7,1,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (7,4,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (8,1,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (9,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (9,3,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (10,1,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (10,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (10,4,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (11,1,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (11,2,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (11,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (12,4,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (14,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (14,4,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (15,1,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (15,3,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (16,1,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (16,2,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (16,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (18,2,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (18,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (18,4,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (19,3,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (19,4,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (20,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (20,2,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (21,2,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (21,4,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (22,3,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (22,4,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (23,4,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (24,1,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (24,2,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (24,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (25,2,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (25,3,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (25,4,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (26,1,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (27,1,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (27,2,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (28,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (28,2,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (29,2,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (29,3,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (29,4,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (30,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (30,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (31,1,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (31,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (33,2,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (33,4,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (34,1,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (35,1,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (35,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (36,2,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (36,3,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (36,4,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (37,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (37,3,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (37,4,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (38,2,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (38,3,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (39,4,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (40,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (40,2,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (40,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (40,4,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (41,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (42,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (42,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (42,4,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (43,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (43,2,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (43,4,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (44,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (45,1,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (45,2,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (45,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (45,4,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (46,1,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (46,2,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (46,3,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (47,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (47,2,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (47,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (47,4,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (48,1,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (48,3,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (48,4,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (49,2,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (49,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (50,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (51,1,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (51,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (51,4,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (52,1,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (52,2,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (52,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (53,2,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (53,3,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (53,4,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (54,1,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (54,2,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (54,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (55,1,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (55,2,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (55,3,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (55,4,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (56,1,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (56,2,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (56,3,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (56,4,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (57,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (57,4,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (58,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (58,2,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (58,4,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (59,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (59,4,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (60,1,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (60,2,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (60,3,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (60,4,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (61,1,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (61,3,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (62,1,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (62,3,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (62,4,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (63,1,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (63,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (64,4,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (65,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (65,3,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (66,1,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (66,2,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (66,4,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (68,2,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (68,4,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (69,1,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (69,2,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (69,3,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (71,3,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (72,2,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (72,4,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (73,1,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (73,2,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (73,4,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (74,1,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (75,2,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (76,3,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (76,4,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (77,3,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (78,4,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (79,2,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (79,3,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (79,4,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (80,1,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (80,2,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (80,3,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (81,1,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (81,3,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (82,1,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (83,1,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (84,1,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (84,2,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (84,3,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (85,1,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (85,4,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (86,1,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (86,2,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (86,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (87,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (87,2,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (88,2,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (89,2,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (89,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (90,2,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (90,3,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (91,4,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (92,2,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (92,4,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (93,2,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (93,4,1);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (95,2,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (95,4,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (96,1,5);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (96,4,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (97,2,0);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (98,1,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (99,1,4);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (99,2,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (99,3,3);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (99,4,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (100,1,2);
INSERT INTO inclure(idreservation,idtypevoyageur,nombrevoyageur) VALUES (100,3,5);

/*==============================================================*/
/* Table : incident (5 incidents)                               */
/*==============================================================*/

INSERT INTO incident(idutilisateur, idreservation, iddate, motifincident, descriptionincident) VALUES

(2, 77, 45659, 'Problème de moisissure', 'En arrivant dans le logement, j''ai découvert de la moisissure dans la salle de bain et la chambre, rendant l''air irrespirable et le séjour très désagréable.'),
(8, 33, 43989, 'Frigo en panne', 'Le frigo du logement ne fonctionnait pas du tout, j''ai dû jeter tous les aliments que j''avais achetés et acheter des glacières pour conserver mes provisions.'),
(12, 37, 44082, 'Fuite d''eau dans le lavabo', 'Le lavabo de la salle de bain fuyait continuellement, provoquant des flaques d''eau et rendant la salle de bain inutilisable.'),
(17, 42, 44836, 'Bruit nocturne incessant', 'Chaque nuit, le voisinage était très bruyant avec des fêtes et de la musique jusqu''à tard, rendant le sommeil impossible et perturbant complètement le séjour.'),
(23, 98, 44670, 'Pas d''eau chaude', 'Malgré l''installation annoncée, l''eau chaude ne fonctionnait pas, ce qui a rendu les douches inconfortables et a compliqué le séjour.');

/*============================================================================================================================================*/
/*============================================================================================================================================*/
/* INSERTIONS NEUVIEME NIVEAU                                                                                                                 */
/*============================================================================================================================================*/
/*============================================================================================================================================*/

/*==============================================================*/
/* Table : photo (100 photos + 4 photos pour les incidents)     */
/*==============================================================*/

INSERT INTO photo (idannonce, idincident, lienphoto) VALUES

-- 2/2. Photos incident
(null, 1, 'https://tse4.mm.bing.net/th/id/OIP.zvHdgquaBDY68leSlLCl4gAAAA?w=300&h=200&rs=1&pid=ImgDetMain&o=7&rm=3'),
(null, 1, 'https://www.galuft.de/wp-content/uploads/2023/07/Schimmel-Wand-800x533.jpg'),
(null, 2, 'https://tse2.mm.bing.net/th/id/OIP.WqNrMvafLth5nF9xsE_YuAHaJ4?w=1350&h=1800&rs=1&pid=ImgDetMain&o=7&rm=3'),
(null, 3, 'https://www.absfloat.com/wp-content/uploads/2020/09/01218-768x546.jpg');

/*==============================================================*/
/* Table : demander (7 lignes)                                  */
/*==============================================================*/

INSERT INTO demander(idincident, idcompensation) VALUES

(1,9),
(2,5),
(2,7),
(3,9),
(4,6),
(4,8),
(5,9);

COMMIT;