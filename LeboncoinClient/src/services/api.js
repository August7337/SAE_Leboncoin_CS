const DEFAULT_API_BASE_URL = 'https://leboncoinapi-b0b2bmazh9ebdqef.spaincentral-01.azurewebsites.net/api'

const normalizeBaseUrl = (url) => (url || '').trim().replace(/\/+$/, '')

const envBaseUrl = normalizeBaseUrl(import.meta.env.VITE_API_BASE_URL)
export const API_BASE_URL = envBaseUrl || DEFAULT_API_BASE_URL

const createJsonRequestOptions = (method, body, options = {}) => {
  const headers = {
    'Content-Type': 'application/json',
    ...(options.headers || {}),
  }

  return {
    ...options,
    method,
    headers,
    body: body === undefined ? undefined : JSON.stringify(body),
  }
}

export const buildApiUrl = (path = '') => {
  const normalizedPath = path.startsWith('/') ? path : `/${path}`
  return `${API_BASE_URL}${normalizedPath}`
}

export const buildAssetUrl = (assetPath = '') => {
  if (!assetPath) return ''
  if (assetPath.startsWith('http://') || assetPath.startsWith('https://')) {
    return assetPath
  }

  return `${API_BASE_URL}/${assetPath.replace(/^\/+/, '')}`
}

export const apiFetch = async (path, options = {}) => {
  const response = await fetch(buildApiUrl(path), {
    ...options,
    cache: 'no-cache'
  })

  if (!response.ok) {
    throw new Error(`Erreur HTTP ${response.status}`)
  }

  return response
}

export const apiJson = async (path, options = {}) => {
  const response = await apiFetch(path, options)

  if (response.status === 204) {
    return null
  }

  return response.json()
}

export const getJson = (path, options = {}) => apiJson(path, { ...options, method: 'GET' })

export const postJson = (path, body, options = {}) =>
  apiJson(path, createJsonRequestOptions('POST', body, options))

export const putJson = (path, body, options = {}) =>
  apiJson(path, createJsonRequestOptions('PUT', body, options))

export const deleteRequest = (path, options = {}) =>
  apiFetch(path, { ...options, method: 'DELETE' })
