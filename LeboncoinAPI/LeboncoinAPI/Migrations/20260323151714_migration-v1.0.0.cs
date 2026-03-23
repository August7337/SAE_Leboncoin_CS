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
            migrationBuilder.CreateTable(
                name: "AnnonceAnnonce",
                columns: table => new
                {
                    IdannonceA = table.Column<int>(type: "integer", nullable: false),
                    IdannonceB = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnnonceAnnonce", x => new { x.IdannonceA, x.IdannonceB });
                });

            migrationBuilder.CreateTable(
                name: "AnnonceUtilisateur",
                columns: table => new
                {
                    Idannonce = table.Column<int>(type: "integer", nullable: false),
                    Idutilisateur = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnnonceUtilisateur", x => new { x.Idannonce, x.Idutilisateur });
                });

            migrationBuilder.CreateTable(
                name: "categorie",
                columns: table => new
                {
                    idcategorie = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomcategorie = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_categorie", x => x.idcategorie);
                });

            migrationBuilder.CreateTable(
                name: "CommoditeRecherche",
                columns: table => new
                {
                    Idcommodite = table.Column<int>(type: "integer", nullable: false),
                    Idrecherche = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CommoditeRecherche", x => new { x.Idcommodite, x.Idrecherche });
                });

            migrationBuilder.CreateTable(
                name: "compensation",
                columns: table => new
                {
                    idcompensation = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomcompensation = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_compensation", x => x.idcompensation);
                });

            migrationBuilder.CreateTable(
                name: "CompensationIncident",
                columns: table => new
                {
                    Idcompensation = table.Column<int>(type: "integer", nullable: false),
                    Idincident = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CompensationIncident", x => new { x.Idcompensation, x.Idincident });
                });

            migrationBuilder.CreateTable(
                name: "date",
                columns: table => new
                {
                    iddate = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    date = table.Column<DateOnly>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_date", x => x.iddate);
                });

            migrationBuilder.CreateTable(
                name: "heure",
                columns: table => new
                {
                    idheure = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    heure = table.Column<TimeOnly>(type: "time without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_heure", x => x.idheure);
                });

            migrationBuilder.CreateTable(
                name: "permission",
                columns: table => new
                {
                    idpermission = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nompermission = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_permission", x => x.idpermission);
                });

            migrationBuilder.CreateTable(
                name: "PermissionRole",
                columns: table => new
                {
                    Idpermission = table.Column<int>(type: "integer", nullable: false),
                    Idrole = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PermissionRole", x => new { x.Idpermission, x.Idrole });
                });

            migrationBuilder.CreateTable(
                name: "RechercheTypehebergement",
                columns: table => new
                {
                    Idrecherche = table.Column<int>(type: "integer", nullable: false),
                    Idtypehebergement = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RechercheTypehebergement", x => new { x.Idrecherche, x.Idtypehebergement });
                });

            migrationBuilder.CreateTable(
                name: "region",
                columns: table => new
                {
                    idregion = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomregion = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_region", x => x.idregion);
                });

            migrationBuilder.CreateTable(
                name: "role",
                columns: table => new
                {
                    idrole = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomrole = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_role", x => x.idrole);
                });

            migrationBuilder.CreateTable(
                name: "RoleUtilisateur",
                columns: table => new
                {
                    Idrole = table.Column<int>(type: "integer", nullable: false),
                    Idutilisateur = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RoleUtilisateur", x => new { x.Idrole, x.Idutilisateur });
                });

            migrationBuilder.CreateTable(
                name: "typevoyageur",
                columns: table => new
                {
                    idtypevoyageur = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomtypevoyageur = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_typevoyageur", x => x.idtypevoyageur);
                });

            migrationBuilder.CreateTable(
                name: "commodite",
                columns: table => new
                {
                    idcommodite = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idcategorie = table.Column<int>(type: "integer", nullable: false),
                    nomcommodite = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_commodite", x => x.idcommodite);
                    table.ForeignKey(
                        name: "fk_commodit_apparteni_categori",
                        column: x => x.idcategorie,
                        principalTable: "categorie",
                        principalColumn: "idcategorie",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "typehebergement",
                columns: table => new
                {
                    idtypehebergement = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idcategorie = table.Column<int>(type: "integer", nullable: false),
                    nomtypehebergement = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_typehebergement", x => x.idtypehebergement);
                    table.ForeignKey(
                        name: "fk_typehebe_classer_categori",
                        column: x => x.idcategorie,
                        principalTable: "categorie",
                        principalColumn: "idcategorie",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "departement",
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
                    table.PrimaryKey("pk_departement", x => x.iddepartement);
                    table.ForeignKey(
                        name: "fk_departem_localiser_region",
                        column: x => x.idregion,
                        principalTable: "region",
                        principalColumn: "idregion",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "permettre",
                columns: table => new
                {
                    idrole = table.Column<int>(type: "integer", nullable: false),
                    idpermission = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_permettre", x => new { x.idrole, x.idpermission });
                    table.ForeignKey(
                        name: "fk_permettre_permission",
                        column: x => x.idpermission,
                        principalTable: "permission",
                        principalColumn: "idpermission",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_permettre_role",
                        column: x => x.idrole,
                        principalTable: "role",
                        principalColumn: "idrole",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "ville",
                columns: table => new
                {
                    idville = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    iddepartement = table.Column<int>(type: "integer", nullable: false),
                    codepostal = table.Column<string>(type: "character(5)", fixedLength: true, maxLength: 5, nullable: false),
                    nomville = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    taxedesejour = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_ville", x => x.idville);
                    table.ForeignKey(
                        name: "fk_ville_situer_departem",
                        column: x => x.iddepartement,
                        principalTable: "departement",
                        principalColumn: "iddepartement",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "adresse",
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
                    table.PrimaryKey("pk_adresse", x => x.idadresse);
                    table.ForeignKey(
                        name: "fk_adresse_posseder_ville",
                        column: x => x.idville,
                        principalTable: "ville",
                        principalColumn: "idville",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "annonce",
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
                    montantacompte = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: true),
                    pourcentageacompte = table.Column<int>(type: "integer", nullable: true),
                    prixnuitee = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: false),
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
                        name: "fk_annonce_arriver_heure",
                        column: x => x.idheurearrivee,
                        principalTable: "heure",
                        principalColumn: "idheure",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_annonce_partir_heure",
                        column: x => x.idheuredepart,
                        principalTable: "heure",
                        principalColumn: "idheure",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_annonce_publier_date",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_annonce_qualifier_typehebe",
                        column: x => x.idtypehebergement,
                        principalTable: "typehebergement",
                        principalColumn: "idtypehebergement",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_annonce_se_trouve_adresse",
                        column: x => x.idadresse,
                        principalTable: "adresse",
                        principalColumn: "idadresse",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "AnnonceCommodite",
                columns: table => new
                {
                    Idcommodite = table.Column<int>(type: "integer", nullable: false),
                    Idannonce = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_proposer", x => new { x.Idcommodite, x.Idannonce });
                    table.ForeignKey(
                        name: "fk_proposer_proposer2_annonce",
                        column: x => x.Idannonce,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_proposer_proposer_commodit",
                        column: x => x.Idcommodite,
                        principalTable: "commodite",
                        principalColumn: "idcommodite",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "relier",
                columns: table => new
                {
                    idannonce = table.Column<int>(type: "integer", nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    estdisponible = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_relier", x => new { x.idannonce, x.iddate });
                    table.ForeignKey(
                        name: "fk_relier_relier2_date",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_relier_relier_annonce",
                        column: x => x.idannonce,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "ressembler",
                columns: table => new
                {
                    idannonce_a = table.Column<int>(type: "integer", nullable: false),
                    idannonce_b = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_ressembler", x => new { x.idannonce_a, x.idannonce_b });
                    table.ForeignKey(
                        name: "fk_ressembler_idannonce_a",
                        column: x => x.idannonce_a,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_ressembler_idannonce_b",
                        column: x => x.idannonce_b,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "attribuer",
                columns: table => new
                {
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    idrole = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_attribuer", x => new { x.idutilisateur, x.idrole });
                    table.ForeignKey(
                        name: "fk_attribuer_role",
                        column: x => x.idrole,
                        principalTable: "role",
                        principalColumn: "idrole",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "avis",
                columns: table => new
                {
                    idavis = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idannonce = table.Column<int>(type: "integer", nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    texteavis = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    nombreetoiles = table.Column<decimal>(type: "numeric(2,1)", precision: 2, scale: 1, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_avis", x => x.idavis);
                    table.ForeignKey(
                        name: "fk_avis_deposer_date",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_avis_noter_annonce",
                        column: x => x.idannonce,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "cartebancaire",
                columns: table => new
                {
                    idcartebancaire = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    nomtitulaire = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    prenomtitulaire = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    numerocartebancaire = table.Column<decimal>(type: "numeric(16,0)", precision: 16, scale: 0, nullable: true),
                    dateexpiration = table.Column<DateOnly>(type: "date", nullable: true),
                    numerocvv = table.Column<decimal>(type: "numeric(3,0)", precision: 3, scale: 0, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_cartebancaire", x => x.idcartebancaire);
                });

            migrationBuilder.CreateTable(
                name: "utilisateur",
                columns: table => new
                {
                    idutilisateur = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idadresse = table.Column<int>(type: "integer", nullable: false),
                    idcartebancaire = table.Column<int>(type: "integer", nullable: true),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    pseudonyme = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    email = table.Column<string>(type: "character varying(320)", maxLength: 320, nullable: false),
                    email_verified_at = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    password = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    telephoneutilisateur = table.Column<string>(type: "character(10)", fixedLength: true, maxLength: 10, nullable: false),
                    phone_verified = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    identity_verified = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    solde = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: false),
                    remember_token = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    two_factor_secret = table.Column<string>(type: "text", nullable: true),
                    two_factor_recovery_codes = table.Column<string>(type: "text", nullable: true),
                    two_factor_confirmed_at = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    profile_photo_path = table.Column<string>(type: "character varying(2048)", maxLength: 2048, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_utilisateur", x => x.idutilisateur);
                    table.ForeignKey(
                        name: "fk_utilisat_creer_date",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_utilisat_enregistr_carteban",
                        column: x => x.idcartebancaire,
                        principalTable: "cartebancaire",
                        principalColumn: "idcartebancaire",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_utilisat_resider_adresse",
                        column: x => x.idadresse,
                        principalTable: "adresse",
                        principalColumn: "idadresse",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "favoriser",
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
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_favorise_favoriser_utilisateur",
                        column: x => x.idutilisateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "message",
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
                    table.PrimaryKey("pk_message", x => x.idmessage);
                    table.ForeignKey(
                        name: "fk_message_associati_date",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_message_expedier_utilisat",
                        column: x => x.idutilisateurexpediteur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_message_recevoir_utilisat",
                        column: x => x.idutilisateurreceveur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "particulier",
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
                    table.PrimaryKey("pk_particulier", x => x.idutilisateur);
                    table.ForeignKey(
                        name: "fk_particulier_heritage__utilisateur",
                        column: x => x.idutilisateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_particulier_naitre_date",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "professionnel",
                columns: table => new
                {
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    numsiret = table.Column<decimal>(type: "numeric(14,0)", precision: 14, scale: 0, nullable: false),
                    nomsociete = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    secteuractivite = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_professionnel", x => x.idutilisateur);
                    table.ForeignKey(
                        name: "fk_professionnel_heritage__utilisateur",
                        column: x => x.idutilisateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "recherche",
                columns: table => new
                {
                    idrecherche = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    idville = table.Column<int>(type: "integer", nullable: true),
                    iddatefinrecherche = table.Column<int>(type: "integer", nullable: true),
                    iddepartement = table.Column<int>(type: "integer", nullable: true),
                    idregion = table.Column<int>(type: "integer", nullable: true),
                    iddatedebutrecherche = table.Column<int>(type: "integer", nullable: true),
                    paiementenligne = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    capaciteminimumvoyageur = table.Column<int>(type: "integer", nullable: true),
                    prixminimum = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: true),
                    prixmaximum = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: true),
                    nombreminimumchambre = table.Column<int>(type: "integer", nullable: true),
                    nombremaximumchambre = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_recherche", x => x.idrecherche);
                    table.ForeignKey(
                        name: "fk_recherch_associati_utilisat",
                        column: x => x.idutilisateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_recherch_associer_ville",
                        column: x => x.idville,
                        principalTable: "ville",
                        principalColumn: "idville",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_recherch_commencer_date",
                        column: x => x.iddatedebutrecherche,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_recherch_connecter_departem",
                        column: x => x.iddepartement,
                        principalTable: "departement",
                        principalColumn: "iddepartement",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_recherch_lier_region",
                        column: x => x.idregion,
                        principalTable: "region",
                        principalColumn: "idregion",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_recherch_terminer_date",
                        column: x => x.iddatefinrecherche,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "reservation",
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
                    telephoneclient = table.Column<string>(type: "character(10)", fixedLength: true, maxLength: 10, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_reservation", x => x.idreservation);
                    table.ForeignKey(
                        name: "fk_reservat_concerner_annonce",
                        column: x => x.idannonce,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_reservat_debuter_date",
                        column: x => x.iddatedebutreservation,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_reservat_finir_date",
                        column: x => x.iddatefinreservation,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_reservation_reserver_utilisateur",
                        column: x => x.idutilisateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "cibler",
                columns: table => new
                {
                    idtypehebergement = table.Column<int>(type: "integer", nullable: false),
                    idrecherche = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_cibler", x => new { x.idtypehebergement, x.idrecherche });
                    table.ForeignKey(
                        name: "fk_cibler_cibler2_recherch",
                        column: x => x.idrecherche,
                        principalTable: "recherche",
                        principalColumn: "idrecherche",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_cibler_cibler_typehebe",
                        column: x => x.idtypehebergement,
                        principalTable: "typehebergement",
                        principalColumn: "idtypehebergement",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "filtrer",
                columns: table => new
                {
                    idrecherche = table.Column<int>(type: "integer", nullable: false),
                    idcommodite = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_filtrer", x => new { x.idrecherche, x.idcommodite });
                    table.ForeignKey(
                        name: "fk_filtrer_filtrer2_commodit",
                        column: x => x.idcommodite,
                        principalTable: "commodite",
                        principalColumn: "idcommodite",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_filtrer_filtrer_recherch",
                        column: x => x.idrecherche,
                        principalTable: "recherche",
                        principalColumn: "idrecherche",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "incident",
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
                        name: "fk_incident_associati_date",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_incident_associati_reservat",
                        column: x => x.idreservation,
                        principalTable: "reservation",
                        principalColumn: "idreservation",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_incident_associati_utilisat",
                        column: x => x.idutilisateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "inclure",
                columns: table => new
                {
                    idreservation = table.Column<int>(type: "integer", nullable: false),
                    idtypevoyageur = table.Column<int>(type: "integer", nullable: false),
                    nombrevoyageur = table.Column<int>(type: "integer", nullable: false, defaultValue: 0)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_inclure", x => new { x.idreservation, x.idtypevoyageur });
                    table.ForeignKey(
                        name: "fk_inclure_inclure2_typevoya",
                        column: x => x.idtypevoyageur,
                        principalTable: "typevoyageur",
                        principalColumn: "idtypevoyageur",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_inclure_inclure_reservat",
                        column: x => x.idreservation,
                        principalTable: "reservation",
                        principalColumn: "idreservation",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "transaction",
                columns: table => new
                {
                    idtransaction = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    idreservation = table.Column<int>(type: "integer", nullable: false),
                    idcartebancaire = table.Column<int>(type: "integer", nullable: false),
                    montanttransaction = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_transaction", x => x.idtransaction);
                    table.ForeignKey(
                        name: "fk_transact_effectuer_date",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_transact_faire_carteban",
                        column: x => x.idcartebancaire,
                        principalTable: "cartebancaire",
                        principalColumn: "idcartebancaire",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_transact_regler_reservat",
                        column: x => x.idreservation,
                        principalTable: "reservation",
                        principalColumn: "idreservation",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "demander",
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
                        principalTable: "compensation",
                        principalColumn: "idcompensation",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_demander_incident",
                        column: x => x.idincident,
                        principalTable: "incident",
                        principalColumn: "idincident",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "photo",
                columns: table => new
                {
                    idphoto = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idannonce = table.Column<int>(type: "integer", nullable: true),
                    idincident = table.Column<int>(type: "integer", nullable: true),
                    lienphoto = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_photo", x => x.idphoto);
                    table.ForeignKey(
                        name: "fk_photo_comporter_annonce",
                        column: x => x.idannonce,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_photo_prouver_incident",
                        column: x => x.idincident,
                        principalTable: "incident",
                        principalColumn: "idincident",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "idx_adresse_idville",
                table: "adresse",
                column: "idville");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_capacite",
                table: "annonce",
                column: "capacite");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_idadresse",
                table: "annonce",
                column: "idadresse");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_iddate",
                table: "annonce",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_idheurearrivee",
                table: "annonce",
                column: "idheurearrivee");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_idheuredepart",
                table: "annonce",
                column: "idheuredepart");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_idtypehebergement",
                table: "annonce",
                column: "idtypehebergement");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_idutilisateur",
                table: "annonce",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_nbchambres",
                table: "annonce",
                column: "nbchambres");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_prixnuitee",
                table: "annonce",
                column: "prixnuitee");

            migrationBuilder.CreateIndex(
                name: "idx_proposer_idannonce",
                table: "AnnonceCommodite",
                column: "Idannonce");

            migrationBuilder.CreateIndex(
                name: "idx_proposer_idcommodite",
                table: "AnnonceCommodite",
                column: "Idcommodite");

            migrationBuilder.CreateIndex(
                name: "IX_attribuer_idrole",
                table: "attribuer",
                column: "idrole");

            migrationBuilder.CreateIndex(
                name: "IX_avis_idannonce",
                table: "avis",
                column: "idannonce");

            migrationBuilder.CreateIndex(
                name: "IX_avis_iddate",
                table: "avis",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "IX_avis_idutilisateur",
                table: "avis",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_cartebancaire_idutilisateur",
                table: "cartebancaire",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "idx_cibler_idrecherche",
                table: "cibler",
                column: "idrecherche");

            migrationBuilder.CreateIndex(
                name: "idx_commodite_idcategorie",
                table: "commodite",
                column: "idcategorie");

            migrationBuilder.CreateIndex(
                name: "idx_date_date",
                table: "date",
                column: "date");

            migrationBuilder.CreateIndex(
                name: "idx_demander_idcompensation",
                table: "demander",
                column: "idcompensation");

            migrationBuilder.CreateIndex(
                name: "idx_departement_idregion",
                table: "departement",
                column: "idregion");

            migrationBuilder.CreateIndex(
                name: "idx_favoriser_idannonce",
                table: "favoriser",
                column: "idannonce");

            migrationBuilder.CreateIndex(
                name: "idx_filtrer_idcommodite",
                table: "filtrer",
                column: "idcommodite");

            migrationBuilder.CreateIndex(
                name: "idx_incident_idreservation",
                table: "incident",
                column: "idreservation");

            migrationBuilder.CreateIndex(
                name: "idx_incident_idutilisateur",
                table: "incident",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_incident_iddate",
                table: "incident",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "idx_inclure_idtypevoyageur",
                table: "inclure",
                column: "idtypevoyageur");

            migrationBuilder.CreateIndex(
                name: "idx_message_idutilisateurexpediteur",
                table: "message",
                column: "idutilisateurexpediteur");

            migrationBuilder.CreateIndex(
                name: "idx_message_idutilisateurreceveur",
                table: "message",
                column: "idutilisateurreceveur");

            migrationBuilder.CreateIndex(
                name: "IX_message_iddate",
                table: "message",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "IX_particulier_iddate",
                table: "particulier",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "IX_permettre_idpermission",
                table: "permettre",
                column: "idpermission");

            migrationBuilder.CreateIndex(
                name: "IX_photo_idannonce",
                table: "photo",
                column: "idannonce");

            migrationBuilder.CreateIndex(
                name: "IX_photo_idincident",
                table: "photo",
                column: "idincident");

            migrationBuilder.CreateIndex(
                name: "professionnel_numsiret_key",
                table: "professionnel",
                column: "numsiret",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_recherche_iddatedebutrecherche",
                table: "recherche",
                column: "iddatedebutrecherche");

            migrationBuilder.CreateIndex(
                name: "IX_recherche_iddatefinrecherche",
                table: "recherche",
                column: "iddatefinrecherche");

            migrationBuilder.CreateIndex(
                name: "IX_recherche_iddepartement",
                table: "recherche",
                column: "iddepartement");

            migrationBuilder.CreateIndex(
                name: "IX_recherche_idregion",
                table: "recherche",
                column: "idregion");

            migrationBuilder.CreateIndex(
                name: "IX_recherche_idutilisateur",
                table: "recherche",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_recherche_idville",
                table: "recherche",
                column: "idville");

            migrationBuilder.CreateIndex(
                name: "region_nomregion_key",
                table: "region",
                column: "nomregion",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "idx_relier_iddate",
                table: "relier",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "idx_reservation_idannonce",
                table: "reservation",
                column: "idannonce");

            migrationBuilder.CreateIndex(
                name: "idx_reservation_iddatedebutres",
                table: "reservation",
                column: "iddatedebutreservation");

            migrationBuilder.CreateIndex(
                name: "idx_reservation_iddatefinres",
                table: "reservation",
                column: "iddatefinreservation");

            migrationBuilder.CreateIndex(
                name: "idx_reservation_idutilisateur",
                table: "reservation",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "idx_ressembler_idannonce_b",
                table: "ressembler",
                column: "idannonce_b");

            migrationBuilder.CreateIndex(
                name: "idx_transaction_idcartebancaire",
                table: "transaction",
                column: "idcartebancaire");

            migrationBuilder.CreateIndex(
                name: "idx_transaction_iddate",
                table: "transaction",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "idx_transaction_idreservation",
                table: "transaction",
                column: "idreservation");

            migrationBuilder.CreateIndex(
                name: "idx_typehebergement_idcategorie",
                table: "typehebergement",
                column: "idcategorie");

            migrationBuilder.CreateIndex(
                name: "typevoyageur_nomtypevoyageur_key",
                table: "typevoyageur",
                column: "nomtypevoyageur",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "idx_utilisateur_idadresse",
                table: "utilisateur",
                column: "idadresse");

            migrationBuilder.CreateIndex(
                name: "idx_utilisateur_idcartebancaire",
                table: "utilisateur",
                column: "idcartebancaire");

            migrationBuilder.CreateIndex(
                name: "idx_utilisateur_iddate",
                table: "utilisateur",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "utilisateur_email_key",
                table: "utilisateur",
                column: "email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "utilisateur_telephoneutilisateur_key",
                table: "utilisateur",
                column: "telephoneutilisateur",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "idx_ville_iddepartement",
                table: "ville",
                column: "iddepartement");

            migrationBuilder.AddForeignKey(
                name: "fk_annonce_diffuser_utilisateur",
                table: "annonce",
                column: "idutilisateur",
                principalTable: "utilisateur",
                principalColumn: "idutilisateur",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "fk_attribuer_utilisateur",
                table: "attribuer",
                column: "idutilisateur",
                principalTable: "utilisateur",
                principalColumn: "idutilisateur",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "fk_avis_commenter_utilisateur",
                table: "avis",
                column: "idutilisateur",
                principalTable: "utilisateur",
                principalColumn: "idutilisateur",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "fk_carteban_enregistr_utilisat",
                table: "cartebancaire",
                column: "idutilisateur",
                principalTable: "utilisateur",
                principalColumn: "idutilisateur",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_adresse_posseder_ville",
                table: "adresse");

            migrationBuilder.DropForeignKey(
                name: "fk_carteban_enregistr_utilisat",
                table: "cartebancaire");

            migrationBuilder.DropTable(
                name: "AnnonceAnnonce");

            migrationBuilder.DropTable(
                name: "AnnonceCommodite");

            migrationBuilder.DropTable(
                name: "AnnonceUtilisateur");

            migrationBuilder.DropTable(
                name: "attribuer");

            migrationBuilder.DropTable(
                name: "avis");

            migrationBuilder.DropTable(
                name: "cibler");

            migrationBuilder.DropTable(
                name: "CommoditeRecherche");

            migrationBuilder.DropTable(
                name: "CompensationIncident");

            migrationBuilder.DropTable(
                name: "demander");

            migrationBuilder.DropTable(
                name: "favoriser");

            migrationBuilder.DropTable(
                name: "filtrer");

            migrationBuilder.DropTable(
                name: "inclure");

            migrationBuilder.DropTable(
                name: "message");

            migrationBuilder.DropTable(
                name: "particulier");

            migrationBuilder.DropTable(
                name: "permettre");

            migrationBuilder.DropTable(
                name: "PermissionRole");

            migrationBuilder.DropTable(
                name: "photo");

            migrationBuilder.DropTable(
                name: "professionnel");

            migrationBuilder.DropTable(
                name: "RechercheTypehebergement");

            migrationBuilder.DropTable(
                name: "relier");

            migrationBuilder.DropTable(
                name: "ressembler");

            migrationBuilder.DropTable(
                name: "RoleUtilisateur");

            migrationBuilder.DropTable(
                name: "transaction");

            migrationBuilder.DropTable(
                name: "compensation");

            migrationBuilder.DropTable(
                name: "commodite");

            migrationBuilder.DropTable(
                name: "recherche");

            migrationBuilder.DropTable(
                name: "typevoyageur");

            migrationBuilder.DropTable(
                name: "permission");

            migrationBuilder.DropTable(
                name: "role");

            migrationBuilder.DropTable(
                name: "incident");

            migrationBuilder.DropTable(
                name: "reservation");

            migrationBuilder.DropTable(
                name: "annonce");

            migrationBuilder.DropTable(
                name: "heure");

            migrationBuilder.DropTable(
                name: "typehebergement");

            migrationBuilder.DropTable(
                name: "categorie");

            migrationBuilder.DropTable(
                name: "ville");

            migrationBuilder.DropTable(
                name: "departement");

            migrationBuilder.DropTable(
                name: "region");

            migrationBuilder.DropTable(
                name: "utilisateur");

            migrationBuilder.DropTable(
                name: "date");

            migrationBuilder.DropTable(
                name: "cartebancaire");

            migrationBuilder.DropTable(
                name: "adresse");
        }
    }
}
