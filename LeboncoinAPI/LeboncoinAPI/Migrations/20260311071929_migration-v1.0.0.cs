using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace LeboncoinAPI.Migrations
{
    /// <inheritdoc />
    public partial class migrationv100 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "public");

            migrationBuilder.CreateTable(
                name: "categorie",
                schema: "public",
                columns: table => new
                {
                    idcategorie = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomcategorie = table.Column<string>(type: "character varying(24)", maxLength: 24, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_categorie", x => x.idcategorie);
                });

            migrationBuilder.CreateTable(
                name: "compensation",
                schema: "public",
                columns: table => new
                {
                    idcompensation = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomcompensation = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_compensation", x => x.idcompensation);
                });

            migrationBuilder.CreateTable(
                name: "date",
                schema: "public",
                columns: table => new
                {
                    iddate = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    date = table.Column<DateTime>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_date", x => x.iddate);
                });

            migrationBuilder.CreateTable(
                name: "heure",
                schema: "public",
                columns: table => new
                {
                    idheure = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    heure = table.Column<TimeSpan>(type: "time", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_heure", x => x.idheure);
                });

            migrationBuilder.CreateTable(
                name: "region",
                schema: "public",
                columns: table => new
                {
                    idregion = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomregion = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_region", x => x.idregion);
                });

            migrationBuilder.CreateTable(
                name: "typevoyageur",
                schema: "public",
                columns: table => new
                {
                    idtypevoyageur = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomtypevoyageur = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_typevoyageur", x => x.idtypevoyageur);
                });

            migrationBuilder.CreateTable(
                name: "commodite",
                schema: "public",
                columns: table => new
                {
                    idcommodite = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idcategorie = table.Column<int>(type: "integer", nullable: false),
                    nomcommodite = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_commodite", x => x.idcommodite);
                    table.ForeignKey(
                        name: "FK_commodite_categorie_idcategorie",
                        column: x => x.idcategorie,
                        principalSchema: "public",
                        principalTable: "categorie",
                        principalColumn: "idcategorie",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "typehebergement",
                schema: "public",
                columns: table => new
                {
                    idtypehebergement = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idcategorie = table.Column<int>(type: "integer", nullable: false),
                    nomtypehebergement = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_typehebergement", x => x.idtypehebergement);
                    table.ForeignKey(
                        name: "FK_typehebergement_categorie_idcategorie",
                        column: x => x.idcategorie,
                        principalSchema: "public",
                        principalTable: "categorie",
                        principalColumn: "idcategorie",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "departement",
                schema: "public",
                columns: table => new
                {
                    iddepartement = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idregion = table.Column<int>(type: "integer", nullable: false),
                    numerodepartement = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: true),
                    nomdepartement = table.Column<string>(type: "character varying(25)", maxLength: 25, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_departement", x => x.iddepartement);
                    table.ForeignKey(
                        name: "FK_departement_region_idregion",
                        column: x => x.idregion,
                        principalSchema: "public",
                        principalTable: "region",
                        principalColumn: "idregion",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ville",
                schema: "public",
                columns: table => new
                {
                    idville = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    iddepartement = table.Column<int>(type: "integer", nullable: false),
                    codepostal = table.Column<string>(type: "char(5)", nullable: false),
                    nomville = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    taxedesejour = table.Column<decimal>(type: "numeric(10,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ville", x => x.idville);
                    table.ForeignKey(
                        name: "FK_ville_departement_iddepartement",
                        column: x => x.iddepartement,
                        principalSchema: "public",
                        principalTable: "departement",
                        principalColumn: "iddepartement",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "adresse",
                schema: "public",
                columns: table => new
                {
                    idadresse = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idville = table.Column<int>(type: "integer", nullable: false),
                    numerorue = table.Column<int>(type: "integer", nullable: true),
                    nomrue = table.Column<string>(type: "character varying(39)", maxLength: 39, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_adresse", x => x.idadresse);
                    table.ForeignKey(
                        name: "FK_adresse_ville_idville",
                        column: x => x.idville,
                        principalSchema: "public",
                        principalTable: "ville",
                        principalColumn: "idville",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "utilisateur",
                schema: "public",
                columns: table => new
                {
                    idutilisateur = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idadresse = table.Column<int>(type: "integer", nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    pseudonyme = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    email = table.Column<string>(type: "character varying(320)", maxLength: 320, nullable: false),
                    email_verified_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    password = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    telephoneutilisateur = table.Column<string>(type: "char(10)", nullable: false),
                    phone_verified = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    identity_verified = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    solde = table.Column<decimal>(type: "numeric(10,2)", nullable: false, defaultValue: 0m),
                    remember_token = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    two_factor_secret = table.Column<string>(type: "text", nullable: true),
                    two_factor_recovery_codes = table.Column<string>(type: "text", nullable: true),
                    two_factor_confirmed_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    profile_photo_path = table.Column<string>(type: "character varying(2048)", maxLength: 2048, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_utilisateur", x => x.idutilisateur);
                    table.ForeignKey(
                        name: "FK_utilisateur_adresse_idadresse",
                        column: x => x.idadresse,
                        principalSchema: "public",
                        principalTable: "adresse",
                        principalColumn: "idadresse",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_utilisateur_date_iddate",
                        column: x => x.iddate,
                        principalSchema: "public",
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "annonce",
                schema: "public",
                columns: table => new
                {
                    idannonce = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idadresse = table.Column<int>(type: "integer", nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    idheuredepart = table.Column<int>(type: "integer", nullable: false),
                    idtypehebergement = table.Column<int>(type: "integer", nullable: false),
                    idheurearrivee = table.Column<int>(type: "integer", nullable: false),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    titreannonce = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    descriptionannonce = table.Column<string>(type: "character varying(4000)", maxLength: 4000, nullable: false),
                    nombreetoilesleboncoin = table.Column<int>(type: "integer", nullable: true),
                    lienphoto = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    montantacompte = table.Column<decimal>(type: "numeric(10,2)", nullable: true),
                    pourcentageacompte = table.Column<int>(type: "integer", nullable: true),
                    prixnuitee = table.Column<decimal>(type: "numeric(10,2)", nullable: false),
                    capacite = table.Column<int>(type: "integer", nullable: true),
                    nbchambres = table.Column<int>(type: "integer", nullable: true),
                    minimumnuitee = table.Column<int>(type: "integer", nullable: true),
                    possibiliteanimaux = table.Column<bool>(type: "boolean", nullable: false),
                    nombrebebesmax = table.Column<int>(type: "integer", nullable: true),
                    possibilitefumeur = table.Column<bool>(type: "boolean", nullable: false),
                    estverifie = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    smsverifie = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_annonce", x => x.idannonce);
                    table.ForeignKey(
                        name: "FK_annonce_adresse_idadresse",
                        column: x => x.idadresse,
                        principalSchema: "public",
                        principalTable: "adresse",
                        principalColumn: "idadresse",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_annonce_date_iddate",
                        column: x => x.iddate,
                        principalSchema: "public",
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_annonce_heure_idheurearrivee",
                        column: x => x.idheurearrivee,
                        principalSchema: "public",
                        principalTable: "heure",
                        principalColumn: "idheure",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_annonce_heure_idheuredepart",
                        column: x => x.idheuredepart,
                        principalSchema: "public",
                        principalTable: "heure",
                        principalColumn: "idheure",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_annonce_typehebergement_idtypehebergement",
                        column: x => x.idtypehebergement,
                        principalSchema: "public",
                        principalTable: "typehebergement",
                        principalColumn: "idtypehebergement",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_annonce_utilisateur_idutilisateur",
                        column: x => x.idutilisateur,
                        principalSchema: "public",
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "message",
                schema: "public",
                columns: table => new
                {
                    idmessage = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idutilisateurreceveur = table.Column<int>(type: "integer", nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    idutilisateurexpediteur = table.Column<int>(type: "integer", nullable: false),
                    contenumessage = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_message", x => x.idmessage);
                    table.ForeignKey(
                        name: "FK_message_utilisateur_idutilisateurexpediteur",
                        column: x => x.idutilisateurexpediteur,
                        principalSchema: "public",
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_message_utilisateur_idutilisateurreceveur",
                        column: x => x.idutilisateurreceveur,
                        principalSchema: "public",
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "particulier",
                schema: "public",
                columns: table => new
                {
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    nomutilisateur = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    prenomutilisateur = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    civilite = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_particulier", x => x.idutilisateur);
                    table.ForeignKey(
                        name: "FK_particulier_utilisateur_idutilisateur",
                        column: x => x.idutilisateur,
                        principalSchema: "public",
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "professionnel",
                schema: "public",
                columns: table => new
                {
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    numsiret = table.Column<decimal>(type: "numeric(14,0)", nullable: false),
                    nomsociete = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    secteuractivite = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_professionnel", x => x.idutilisateur);
                    table.ForeignKey(
                        name: "FK_professionnel_utilisateur_idutilisateur",
                        column: x => x.idutilisateur,
                        principalSchema: "public",
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "avis",
                schema: "public",
                columns: table => new
                {
                    idavis = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idannonce = table.Column<int>(type: "integer", nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    texteavis = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    nombreetoiles = table.Column<decimal>(type: "numeric(2,1)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_avis", x => x.idavis);
                    table.ForeignKey(
                        name: "FK_avis_annonce_idannonce",
                        column: x => x.idannonce,
                        principalSchema: "public",
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_avis_utilisateur_idutilisateur",
                        column: x => x.idutilisateur,
                        principalSchema: "public",
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "favoriser",
                schema: "public",
                columns: table => new
                {
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    idannonce = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_favoriser", x => new { x.idutilisateur, x.idannonce });
                    table.ForeignKey(
                        name: "fk_favorise_favoriser_annonce",
                        column: x => x.idannonce,
                        principalSchema: "public",
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_favorise_favoriser_utilisateur",
                        column: x => x.idutilisateur,
                        principalSchema: "public",
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "proposer",
                schema: "public",
                columns: table => new
                {
                    idcommodite = table.Column<int>(type: "integer", nullable: false),
                    idannonce = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_proposer", x => new { x.idcommodite, x.idannonce });
                    table.ForeignKey(
                        name: "fk_proposer_proposer2_annonce",
                        column: x => x.idannonce,
                        principalSchema: "public",
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_proposer_proposer_commodit",
                        column: x => x.idcommodite,
                        principalSchema: "public",
                        principalTable: "commodite",
                        principalColumn: "idcommodite",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "reservation",
                schema: "public",
                columns: table => new
                {
                    idreservation = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idannonce = table.Column<int>(type: "integer", nullable: false),
                    iddatedebutreservation = table.Column<int>(type: "integer", nullable: false),
                    iddatefinreservation = table.Column<int>(type: "integer", nullable: false),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    nomclient = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    prenomclient = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    telephoneclient = table.Column<string>(type: "char(10)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_reservation", x => x.idreservation);
                    table.ForeignKey(
                        name: "FK_reservation_annonce_idannonce",
                        column: x => x.idannonce,
                        principalSchema: "public",
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_reservation_utilisateur_idutilisateur",
                        column: x => x.idutilisateur,
                        principalSchema: "public",
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "incident",
                schema: "public",
                columns: table => new
                {
                    idincident = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    idreservation = table.Column<int>(type: "integer", nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    motifincident = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    descriptionincident = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                    etape = table.Column<int>(type: "integer", nullable: false, defaultValue: 1),
                    estclasse = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    estrembourse = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    estremisaucontentieux = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    explicationproprietaire = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_incident", x => x.idincident);
                    table.ForeignKey(
                        name: "FK_incident_date_iddate",
                        column: x => x.iddate,
                        principalSchema: "public",
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_incident_reservation_idreservation",
                        column: x => x.idreservation,
                        principalSchema: "public",
                        principalTable: "reservation",
                        principalColumn: "idreservation",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_incident_utilisateur_idutilisateur",
                        column: x => x.idutilisateur,
                        principalSchema: "public",
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "demander",
                schema: "public",
                columns: table => new
                {
                    idincident = table.Column<int>(type: "integer", nullable: false),
                    idcompensation = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_demander", x => new { x.idincident, x.idcompensation });
                    table.ForeignKey(
                        name: "fk_demander_compensation",
                        column: x => x.idcompensation,
                        principalSchema: "public",
                        principalTable: "compensation",
                        principalColumn: "idcompensation",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_demander_incident",
                        column: x => x.idincident,
                        principalSchema: "public",
                        principalTable: "incident",
                        principalColumn: "idincident",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_adresse_idville",
                schema: "public",
                table: "adresse",
                column: "idville");

            migrationBuilder.CreateIndex(
                name: "IX_annonce_idadresse",
                schema: "public",
                table: "annonce",
                column: "idadresse");

            migrationBuilder.CreateIndex(
                name: "IX_annonce_iddate",
                schema: "public",
                table: "annonce",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "IX_annonce_idheurearrivee",
                schema: "public",
                table: "annonce",
                column: "idheurearrivee");

            migrationBuilder.CreateIndex(
                name: "IX_annonce_idheuredepart",
                schema: "public",
                table: "annonce",
                column: "idheuredepart");

            migrationBuilder.CreateIndex(
                name: "IX_annonce_idtypehebergement",
                schema: "public",
                table: "annonce",
                column: "idtypehebergement");

            migrationBuilder.CreateIndex(
                name: "IX_annonce_idutilisateur",
                schema: "public",
                table: "annonce",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_avis_idannonce",
                schema: "public",
                table: "avis",
                column: "idannonce");

            migrationBuilder.CreateIndex(
                name: "IX_avis_idutilisateur",
                schema: "public",
                table: "avis",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_commodite_idcategorie",
                schema: "public",
                table: "commodite",
                column: "idcategorie");

            migrationBuilder.CreateIndex(
                name: "IX_demander_idcompensation",
                schema: "public",
                table: "demander",
                column: "idcompensation");

            migrationBuilder.CreateIndex(
                name: "IX_departement_idregion",
                schema: "public",
                table: "departement",
                column: "idregion");

            migrationBuilder.CreateIndex(
                name: "IX_favoriser_idannonce",
                schema: "public",
                table: "favoriser",
                column: "idannonce");

            migrationBuilder.CreateIndex(
                name: "IX_incident_iddate",
                schema: "public",
                table: "incident",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "IX_incident_idreservation",
                schema: "public",
                table: "incident",
                column: "idreservation");

            migrationBuilder.CreateIndex(
                name: "IX_incident_idutilisateur",
                schema: "public",
                table: "incident",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_message_idutilisateurexpediteur",
                schema: "public",
                table: "message",
                column: "idutilisateurexpediteur");

            migrationBuilder.CreateIndex(
                name: "IX_message_idutilisateurreceveur",
                schema: "public",
                table: "message",
                column: "idutilisateurreceveur");

            migrationBuilder.CreateIndex(
                name: "IX_professionnel_numsiret",
                schema: "public",
                table: "professionnel",
                column: "numsiret",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_proposer_idannonce",
                schema: "public",
                table: "proposer",
                column: "idannonce");

            migrationBuilder.CreateIndex(
                name: "IX_reservation_idannonce",
                schema: "public",
                table: "reservation",
                column: "idannonce");

            migrationBuilder.CreateIndex(
                name: "IX_reservation_idutilisateur",
                schema: "public",
                table: "reservation",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_typehebergement_idcategorie",
                schema: "public",
                table: "typehebergement",
                column: "idcategorie");

            migrationBuilder.CreateIndex(
                name: "IX_utilisateur_idadresse",
                schema: "public",
                table: "utilisateur",
                column: "idadresse");

            migrationBuilder.CreateIndex(
                name: "IX_utilisateur_iddate",
                schema: "public",
                table: "utilisateur",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "uq_utilisateur_email",
                schema: "public",
                table: "utilisateur",
                column: "email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "uq_utilisateur_telephone",
                schema: "public",
                table: "utilisateur",
                column: "telephoneutilisateur",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ville_iddepartement",
                schema: "public",
                table: "ville",
                column: "iddepartement");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "avis",
                schema: "public");

            migrationBuilder.DropTable(
                name: "demander",
                schema: "public");

            migrationBuilder.DropTable(
                name: "favoriser",
                schema: "public");

            migrationBuilder.DropTable(
                name: "message",
                schema: "public");

            migrationBuilder.DropTable(
                name: "particulier",
                schema: "public");

            migrationBuilder.DropTable(
                name: "professionnel",
                schema: "public");

            migrationBuilder.DropTable(
                name: "proposer",
                schema: "public");

            migrationBuilder.DropTable(
                name: "typevoyageur",
                schema: "public");

            migrationBuilder.DropTable(
                name: "compensation",
                schema: "public");

            migrationBuilder.DropTable(
                name: "incident",
                schema: "public");

            migrationBuilder.DropTable(
                name: "commodite",
                schema: "public");

            migrationBuilder.DropTable(
                name: "reservation",
                schema: "public");

            migrationBuilder.DropTable(
                name: "annonce",
                schema: "public");

            migrationBuilder.DropTable(
                name: "heure",
                schema: "public");

            migrationBuilder.DropTable(
                name: "typehebergement",
                schema: "public");

            migrationBuilder.DropTable(
                name: "utilisateur",
                schema: "public");

            migrationBuilder.DropTable(
                name: "categorie",
                schema: "public");

            migrationBuilder.DropTable(
                name: "adresse",
                schema: "public");

            migrationBuilder.DropTable(
                name: "date",
                schema: "public");

            migrationBuilder.DropTable(
                name: "ville",
                schema: "public");

            migrationBuilder.DropTable(
                name: "departement",
                schema: "public");

            migrationBuilder.DropTable(
                name: "region",
                schema: "public");
        }
    }
}
