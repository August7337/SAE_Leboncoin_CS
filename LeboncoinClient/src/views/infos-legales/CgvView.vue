<template>
  <div class="bg-gray-50 min-h-screen pt-24 pb-16">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
      
      <div class="mb-10 text-center">
        <h1 class="text-3xl font-black text-slate-900 mb-4">Conditions générales de vente du Service leboncoin</h1>
        <p class="text-slate-500">Document historisé le 24/03/2026 à 10:46:40 (UTC)</p>
      </div>

      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-10">
        <div 
          v-for="(section, index) in cgvSections" 
          :key="index" 
          :ref="el => { if (el) sectionRefs[index] = el }"
          class="border-b border-gray-100 last:border-0 scroll-mt-28"
        >
          
          <button 
            @click="toggleSection(index)" 
            class="w-full flex items-center justify-between p-6 text-left focus:outline-none hover:bg-slate-50 transition-colors"
          >
            <h2 class="text-lg font-bold text-slate-900" :class="{ 'text-orange-600': activeIndex === index }">
              {{ section.title }}
            </h2>
            <svg 
              class="w-5 h-5 text-slate-400 flex-shrink-0 transform transition-transform duration-200"
              :class="{ 'rotate-180': activeIndex === index }"
              fill="none" viewBox="0 0 24 24" stroke="currentColor"
            >
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
            </svg>
          </button>

          <transition 
            enter-active-class="transition-[max-height,opacity] duration-300 ease-in-out overflow-hidden"
            enter-from-class="max-h-0 opacity-0"
            enter-to-class="max-h-[5000px] opacity-100"
            leave-active-class="transition-[max-height,opacity] duration-300 ease-in-out overflow-hidden"
            leave-from-class="max-h-[5000px] opacity-100"
            leave-to-class="max-h-0 opacity-0"
          >
            <div v-show="activeIndex === index">
              <div class="p-6 pt-0 text-slate-600 text-sm leading-relaxed prose prose-slate max-w-none" v-html="section.content">
              </div>
            </div>
          </transition>
        </div>
      </div>

      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 text-center flex flex-col items-center">
        <div class="w-12 h-12 bg-orange-100 rounded-full flex items-center justify-center mb-4">
          <svg class="w-6 h-6 text-orange-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
        </div>
        <h3 class="text-lg font-bold text-slate-900 mb-2">Conserver une copie</h3>
        <p class="text-slate-500 text-sm mb-6">Vous pouvez télécharger l'intégralité de nos Conditions Générales de Vente au format PDF.</p>
        
        <a 
          href="/cgv.pdf" 
          target="_blank"
          title="Télécharger" 
          class="inline-flex items-center justify-center gap-2 whitespace-nowrap px-6 h-14 font-bold rounded-xl cursor-pointer bg-slate-900 text-white hover:bg-slate-800 transition-colors"
        >
          <svg viewBox="0 0 24 24" fill="currentColor" class="flex-shrink-0 w-6 h-6" aria-hidden="true" focusable="false">
            <path fill-rule="evenodd" clip-rule="evenodd" d="M20.4826 9.46335C20.4826 9.35223 20.4566 9.24112 20.4132 9.13856C20.3612 9.01035 20.2831 8.89924 20.1877 8.80523L13.1859 1.89924C13.0905 1.80523 12.9777 1.7283 12.8475 1.67702C12.7261 1.62574 12.5959 1.6001 12.4571 1.6001C12.4571 1.6001 12.4571 1.6001 12.4484 1.6001H5.43803C4.78731 1.6001 4.17129 1.85651 3.71145 2.30095C3.25161 2.75394 3 3.36078 3 4.00181V19.1984C3 19.8394 3.26029 20.4463 3.71145 20.8992C4.17129 21.3522 4.78731 21.6001 5.43803 21.6001H18.062C18.7127 21.6001 19.3287 21.3437 19.7885 20.8992C20.2484 20.4463 20.5 19.8394 20.5 19.1984V9.53172C20.5 9.50608 20.4913 9.48899 20.4826 9.46335ZM14.6262 16.1215L12.4571 18.2582C12.3617 18.3522 12.2402 18.4292 12.1187 18.4804C11.9973 18.5317 11.8671 18.5574 11.737 18.5574C11.468 18.5574 11.2251 18.4548 11.0429 18.2924C11.0342 18.2839 11.0255 18.2753 11.0169 18.2668L8.84779 16.13C8.44869 15.7368 8.44869 15.1044 8.84779 14.7112C9.2469 14.318 9.88894 14.318 10.2881 14.7112L10.7219 15.1386V11.5061C10.7219 10.9505 11.173 10.5061 11.737 10.5061C12.3009 10.5061 12.7521 10.9505 12.7521 11.5061V15.1386L13.1859 14.7112C13.585 14.318 14.2271 14.318 14.6262 14.7112C15.0253 15.1044 15.0253 15.7368 14.6262 16.13V16.1215ZM13.4809 8.50608V5.10437L16.9341 8.50608H13.4809Z"></path>
          </svg>
          <span class="sr-only">Télécharger</span>
          Télécharger
        </a>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const activeIndex = ref(0);

const sectionRefs = ref([]);

const toggleSection = (index) => {
  if (activeIndex.value === index) {
    activeIndex.value = null;
  } else {
    activeIndex.value = index;
    
    setTimeout(() => {
      if (sectionRefs.value[index]) {
        sectionRefs.value[index].scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    }, 300); 
  }
};

const cgvSections = [
  {
    title: "1. Définitions",
    content: `
      <p class="mb-4">Chacun des termes mentionnés ci-dessous aura dans les présentes Conditions Générales de Vente du Service leboncoin (ci-après dénommées les « CGV ») la signification suivante :</p>
      <ul class="space-y-4">
        <li><strong>Annonce :</strong> désigne l'ensemble des éléments et données (visuelles, textuelles, sonores, photographies, dessins), déposé par un Annonceur sous sa responsabilité éditoriale, en vue d'acheter, de louer ou de vendre un bien ou un service ou de rechercher un service ou un emploi, et diffusé sur le Site Internet et les Applications.</li>
        <li><strong>Annonceur :</strong> désigne dans les présentes conditions générales de vente, toute personne physique, majeure ou morale établie en France (inclus les DOM à l'exclusion de Mayotte et des COM), titulaire d'un Compte Personnel, et ayant déposé et mis en ligne une Annonce via le Service LEBONCOIN et agissant exclusivement à des fins privées et non professionnelles. Tout Annonceur Professionnel est dans l'obligation d'ouvrir un Compte Pro. Tout Annonceur doit impérativement être connecté à son Compte Personnel pour déposer et gérer ses Annonces. Tout premier dépôt d'annonce entraîne automatiquement la création d'un Compte Personnel.</li>
        <li><strong>Applications :</strong> désigne l'application Android téléchargeable gratuitement sur un téléphone Android depuis le Google Play Store, et l'application optimisée pour iPhone et iPad.</li>
        <li><strong>Compte Personnel :</strong> désigne l'espace accessible depuis le Site Internet et les Applications que tout Annonceur doit se créer et auquel il doit se connecter.</li>
        <li><strong>Compte Pro :</strong> désigne l'espace accessible depuis le Site et les Applications, que tout Annonceur Professionnel doit se créer afin d'utiliser le Service LEBONCOIN.</li>
        <li><strong>LBC FRANCE :</strong> désigne la société qui édite et exploite le Site Internet et les Applications LBC FRANCE, SAS au capital de 3.302.390 euros, immatriculée au RCS de Paris sous le numéro 521.724.336 dont le siège social est situé 24 rue des Jeûneurs, 75002 Paris.</li>
        <li><strong>Pack Top Visibilité :</strong> désigne l'abonnement pouvant être souscrit par un Annonceur connecté à son Compte Personnel lors de la diffusion d'une Annonce dans la catégorie Ventes Immobilières. Ce pack comprend les options payantes suivantes : Modification de l'annonce en illimité, Pack Photos supplémentaires, Remonter mon Annonce chaque semaine pendant 8 semaines.</li>
        <li><strong>Pass Locataire+ :</strong> désigne le service payant proposé par LBC France aux Utilisateurs, personnes physiques majeures, titulaires d'un Compte Personnel et éligibles, recherchant un bien immobilier dans la catégorie "Locations immobilières". À l'issue d'un parcours de vérification via MiTrust, l'Utilisateur obtient un badge "Profil vérifié" et "Revenus vérifiés".</li>
        <li><strong>Service client :</strong> désigne le service de LBC FRANCE auprès duquel l'Annonceur peut obtenir toute information complémentaire. Ce service peut être contacté par e-mail.</li>
        <li><strong>Service leboncoin :</strong> désigne les services leboncoin mis à la disposition des Utilisateurs et des Annonceurs sur le Site Internet et les Applications.</li>
        <li><strong>Site Internet :</strong> désigne le site internet exploité par LBC FRANCE accessible principalement depuis l'URL www.leboncoin.fr.</li>
        <li><strong>Utilisateur :</strong> désigne tout visiteur, ayant accès au Service leboncoin via le Site Internet et/ou les Applications.</li>
      </ul>
    `
  },
  {
    title: "2. Objet",
    content: "<p>Les présentes Conditions Générales de Vente (CGV) établissent les conditions contractuelles applicables à toute souscription, par un Annonceur connecté à son Compte Personnel, d'option(s) payante(s) et d'achat de crédits depuis le Site Internet et les Applications.</p>"
  },
  {
    title: "3. Acceptation",
    content: "<p>Toute souscription d'option(s) payante(s) et/ou achat de crédits par un Annonceur vaut acceptation pleine et entière des CGV en vigueur.</p>"
  },
  {
    title: "4. Modalités de souscription aux options payantes, au Pack Top Visibilité et de paiement des frais d'insertion",
    content: `
      <h4 class="font-bold text-slate-900 mt-4 mb-2">4.1 Règles générales</h4>
      <h5 class="font-bold text-slate-800 mt-2 mb-1">4.1.1 Options payantes</h5>
      <p class="mb-2">La souscription d'une ou plusieurs option(s) payante(s) est exclusivement accessible aux Annonceurs connectés à leur Compte Personnel depuis le Site Internet et/ou les Applications. Une option payante n'est souscrite que pour une seule Annonce. En conséquence, il n'est pas possible de transférer le bénéfice d'une option payante d'une Annonce à une autre.</p>
      <p class="mb-2">Sauf dans les catégories Véhicules, Immobilier et Services, les Annonces sont classées par défaut en fonction de leur pertinence au regard de la recherche de l'Utilisateur. Dans les catégories Véhicules, Immobilier et Services, les Annonces sont classées par défaut par ordre chronologique en fonction de la date et de l'heure de leur mise en ligne.</p>
      
      <h5 class="font-bold text-slate-800 mt-4 mb-1">4.1.2 Paiement des frais d'insertion</h5>
      <p class="mb-2">Le dépôt d'Annonces sur le Site est en principe gratuit. Toutefois, dans certaines catégories, des frais d'insertion s'appliquent au-delà d'un certain nombre d'Annonces diffusées sur une période de douze (12) mois glissants. Ces seuils sont les suivants :</p>
      <ul class="list-disc pl-5 space-y-2 mb-4">
        <li><strong>Utilitaires et Voitures :</strong> Gratuit pour les deux premiers véhicules distincts. À partir du troisième, des frais d'insertion s'appliquent.</li>
        <li><strong>Bureaux et Commerces :</strong> Gratuit pour les deux premiers biens immobiliers distincts.</li>
        <li><strong>Colocations et Locations :</strong> Gratuit pour les quatre premiers biens distincts. À partir du cinquième, des frais d'insertion s'appliquent.</li>
        <li><strong>Ventes immobilières :</strong> Gratuit pour les trois premiers biens distincts.</li>
      </ul>
      <p class="mb-4">Dès lors que le seuil est dépassé dans l'une des sous-catégories de la catégorie "Immobilier", le dépôt devient payant dans l'ensemble des sous-catégories. Toute prolongation d'une Annonce est assimilée à un nouveau dépôt pris en compte dans l'application des seuils.</p>

      <h5 class="font-bold text-slate-800 mt-4 mb-1">4.1.3 Pack Top Visibilité</h5>
      <p class="mb-4">La souscription au Pack Top Visibilité est exclusivement accessible aux Annonceurs connectés à leur Compte Personnel. Le Pack ne peut être souscrit que pour la diffusion d'une Annonce dans la catégorie Ventes Immobilières.</p>

      <h4 class="font-bold text-slate-900 mt-6 mb-2">4.2 Espace et Moment de souscription</h4>
      <p class="mb-2">Les options payantes peuvent être souscrites depuis le formulaire de dépôt lors du dépôt, de la modification ou de la prolongation d'une Annonce, ou à tout moment au cours de la diffusion d'une Annonce via le bouton "Mettre en Avant". Le Pack Photos Supplémentaires ne peut être souscrit qu'au moment du dépôt, de la modification, ou de la prolongation.</p>

      <h4 class="font-bold text-slate-900 mt-6 mb-2">4.3 Durée des option(s) payante(s)</h4>
      <p class="mb-2">À l'exception de certaines options (7 ou 30 jours), toute option payante est souscrite pour la durée de diffusion de l'Annonce hors prolongation : soit pour une durée maximum de soixante (60) jours. La souscription d'une option payante ne prolonge pas la durée de l'Annonce. Lors du retrait anticipé de l'Annonce, l'option payante cesse de produire ses effets.</p>
    `
  },
  {
    title: "5. Description des options payantes",
    content: `
      <h4 class="font-bold text-slate-900 mt-4 mb-2">5.1 Modification de l'Annonce</h4>
      <p class="mb-4">Cette option permet de modifier certains champs de votre Annonce (nom, téléphone, titre, paramètres spécifiques, descriptif, prix, photos, code postal, ville). Si l'Annonce modifiée est publiée, elle sera immédiatement remontée en tête de liste.</p>
      
      <h4 class="font-bold text-slate-900 mt-4 mb-2">5.2 Remonter mon Annonce</h4>
      <ul class="list-disc pl-5 space-y-2 mb-4">
        <li><strong>Immédiatement :</strong> Remontée instantanée dans la liste des résultats.</li>
        <li><strong>Chaque jour pendant 7 jours :</strong> Remontée quotidienne pendant 7 jours consécutifs.</li>
        <li><strong>Chaque jour pendant 30 jours :</strong> Remontée quotidienne pendant 30 jours.</li>
        <li><strong>Chaque semaine pendant 8 semaines :</strong> Remontée hebdomadaire.</li>
      </ul>

      <h4 class="font-bold text-slate-900 mt-4 mb-2">5.3 Ajouter un Logo Urgent</h4>
      <p class="mb-4">Cette option permet d'afficher un logo urgent sur une Annonce.</p>

      <h4 class="font-bold text-slate-900 mt-4 mb-2">5.4 Mettre mon annonce A la Une</h4>
      <p class="mb-4">Cette option permet de diffuser une Annonce en première ou en deuxième position de la page de la liste de résultats. Les Annonces s'afficheront de manière aléatoire parmi les Annonces bénéficiant de l'option.</p>

      <h4 class="font-bold text-slate-900 mt-4 mb-2">5.5 Pack Photos supplémentaires</h4>
      <p class="mb-4">Cette option permet d'ajouter dix-sept (17) photographies supplémentaires dans une Annonce (total de 20 photographies).</p>

      <h4 class="font-bold text-slate-900 mt-4 mb-2">5.6 Ajouter l'option Focus</h4>
      <p>Accessible aux professionnels de l'immobilier, elle permet de mettre en avant une Annonce avec l'affichage d'une photo plus grande.</p>
    `
  },
  {
    title: "6. Souscription au Pass Locataire+",
    content: `
      <h4 class="font-bold text-slate-900 mt-4 mb-2">6.1 Conditions d'éligibilité</h4>
      <p class="mb-4">Accessible aux Utilisateurs titulaires d'un contrat de travail (CDI, CDD, intérim), demandeurs d'emploi ou retraités, disposant d'une déclaration d'impôt individuelle.</p>
      
      <h4 class="font-bold text-slate-900 mt-4 mb-2">6.2 Modalités et fonctionnement</h4>
      <p class="mb-4">L'Utilisateur réalise un parcours de vérification d'identité et de revenus via MiTrust. Les nom, prénom et montants renseignés sont verrouillés pendant la durée de validité du Pass Locataire+. LBC France ne garantit ni la sélection du candidat ni la conclusion d'un contrat de bail.</p>

      <h4 class="font-bold text-slate-900 mt-4 mb-2">6.3 Mise en avant auprès des bailleurs</h4>
      <p class="mb-4">Les candidatures bénéficient d'une remontée dans l'Espace Bailleur et se voient apposer les badges "Identité vérifiée" et "Revenus vérifiés". L'attestation de revenus peut être téléchargée pour être fournie au bailleur sous la seule responsabilité de l'Utilisateur.</p>

      <h4 class="font-bold text-slate-900 mt-4 mb-2">6.4 Durée et renouvellement</h4>
      <p class="mb-4">Le Pass Locataire+ est activé pour une durée de 31 jours calendaires sans reconduction tacite. À l'issue, l'accès aux badges et à l'attestation prend fin.</p>

      <h4 class="font-bold text-slate-900 mt-4 mb-2">6.5 Responsabilités et garanties</h4>
      <p>LBC ne saurait être tenue responsable du refus d'un bailleur ou d'éventuelles erreurs. L'Utilisateur s'engage à fournir des informations exactes sous peine de suspension immédiate du Pass.</p>
    `
  },
  {
    title: "7. Prix",
    content: `
      <p class="mb-4">Les tarifs appliqués sont ceux en vigueur au jour de l'achat. LBC FRANCE se réserve la possibilité de modifier ses prix à tout moment.</p>
      <ul class="list-disc pl-5 space-y-2">
        <li><strong>Options payantes :</strong> Varient en fonction de l'option et de la catégorie.</li>
        <li><strong>Frais d'insertion :</strong> Varient en fonction de la catégorie.</li>
        <li><strong>Pack Top Visibilité :</strong> 69,90 euros TTC.</li>
        <li><strong>Pass Locataire+ :</strong> 14,90 euros TTC.</li>
      </ul>
    `
  },
  {
    title: "8. Paiement et facturation",
    content: `
      <h4 class="font-bold text-slate-900 mt-4 mb-2">8.1, 8.2 & 8.3 Paiement des options</h4>
      <p class="mb-4">Le paiement est exigible lors de la souscription. Il s'effectue par carte bancaire, Paypal ou via le porte-monnaie selon l'option. Les factures et justificatifs (PDF) sont disponibles dans l'onglet "Mes Achats" du Compte Personnel.</p>

      <h4 class="font-bold text-slate-900 mt-4 mb-2">8.5 Remboursement et Rétractation</h4>
      <p class="mb-2"><strong>8.5.1 Remboursement :</strong> Les options payantes et le Pack Top Visibilité ne sont pas remboursables. Si la diffusion est refusée pour non-conformité au moment du dépôt, le montant ne sera pas prélevé. Si elle est supprimée en cours de diffusion pour signalement abusif justifié, aucun remboursement n'est dû.</p>
      <p class="mb-4">La suppression d'un Compte Personnel entraîne la suppression des Annonces et options sans droit à remboursement.</p>

      <p class="mb-2"><strong>8.5.2 Remboursement (Pass Locataire+) :</strong> Remboursement possible uniquement si l'Utilisateur n'a pas pu finaliser le parcours dans les 31 jours pour des raisons exceptionnelles (dysfonctionnement technique imputable à MiTrust, situation particulière liée à impots.gouv).</p>

      <p class="mb-2"><strong>8.5.3 Rétractation :</strong> En application des articles L 221-18 du code de la consommation, l'Annonceur dispose d'un délai de 14 jours francs. Toutefois, si les options ont été utilisées avant l'expiration du délai, l'Annonceur renonce expressément à son droit de rétractation.</p>
    `
  },
  {
    title: "9. Responsabilité, Force majeure",
    content: "<p>La responsabilité de LBC FRANCE ne peut être engagée en cas d'inexécution ou de mauvaise exécution de la commande due, soit du fait de l'Annonceur, soit d'un cas de force majeure.</p>"
  },
  {
    title: "10. Modification des CGV",
    content: "<p>Les présentes CGV sont applicables à partir du 08 février 2017. LBC FRANCE se réserve la possibilité, à tout moment, de modifier en tout ou partie les CGV. Les Annonceurs sont invités à consulter régulièrement les CGV afin de prendre connaissance des changements apportés.</p>"
  },
  {
    title: "11. Dispositions diverses",
    content: `
      <p class="mb-2">Tout traitement de données personnelles dans le cadre des présentes est soumis aux dispositions de notre politique de confidentialité, qui fait partie intégrante des présentes CGV.</p>
      <p class="mb-2">Si une partie des CGV devait s'avérer illégale, invalide ou inapplicable, les dispositions en question seraient réputées non écrites, sans remettre en cause la validité des autres dispositions.</p>
      <p class="mb-2">Toute réclamation doit être adressée au Service Client de LBC FRANCE.</p>
      <p class="mb-2">Les Utilisateurs sont informés de la liste d'opposition au démarchage téléphonique « Bloctel » sur laquelle ils peuvent s'inscrire : https://conso.bloctel.fr/.</p>
      <p>Les CGV sont soumises au droit français.</p>
    `
  }
];
</script>

<style scoped>
.prose p { margin-bottom: 0.5rem; }
.prose ul { list-style-type: disc; padding-left: 1.5rem; }
</style>