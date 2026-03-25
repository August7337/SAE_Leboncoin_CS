import api from '@/api/axios'

const incidentsService = {
  create(payload) {
    return api.post('/Incidents', payload).then((response) => response.data)
  },

  getById(id) {
    return api.get(`/Incidents/${id}`).then((response) => response.data)
  },

  getMesIncidents() {
    return api.get('/Incidents/mes-incidents').then((response) => response.data)
  },

  getByReservation(idReservation) {
    return api.get(`/Incidents/reservation/${idReservation}`).then((response) => response.data)
  },

  transition(id, codeStatutCible) {
    return api.post(`/Incidents/${id}/transition`, { codeStatutCible }).then((response) => response.data)
  },

  soumettreExplication(id, explication) {
    return api.post(`/Incidents/${id}/explication-proprietaire`, { explication }).then((response) => response.data)
  },

  getStatuts() {
    return api.get('/Incidents/statuts').then((response) => response.data)
  },

  getTimeline(id) {
    return api.get(`/Incidents/${id}/timeline`).then((response) => response.data)
  },

  assignerAgent(id, idagentAssigne) {
    return api.post(`/Incidents/${id}/assigner-agent`, { idagentAssigne }).then((response) => response.data)
  },

  prendreEnCharge(id) {
    return api.post(`/Incidents/${id}/prise-en-charge`).then((response) => response.data)
  },

  classerSansSuite(id) {
    return api.post(`/Incidents/${id}/classe-sans-suite`).then((response) => response.data)
  },

  demanderExplicationProprietaire(id) {
    return api.post(`/Incidents/${id}/demande-explication-proprietaire`).then((response) => response.data)
  },

  decisionServiceLocation(id, codeStatutCible) {
    return api.post(`/Incidents/${id}/decision-service-location`, { codeStatutCible }).then((response) => response.data)
  },

  decisionLocataire(id, codeStatutCible) {
    return api.post(`/Incidents/${id}/decision-locataire`, { codeStatutCible }).then((response) => response.data)
  },

  decisionContentieux(id, codeStatutCible) {
    return api.post(`/Incidents/${id}/decision-contentieux`, { codeStatutCible }).then((response) => response.data)
  },

  validerRemboursement(id) {
    return api.post(`/Incidents/${id}/validation-remboursement`).then((response) => response.data)
  },

  uploadPhoto(id, file, origine) {
    const formData = new FormData()
    formData.append('file', file)
    formData.append('origine', origine)
    return api.post(`/Incidents/${id}/photos`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    }).then((response) => response.data)
  },
}

export default incidentsService
