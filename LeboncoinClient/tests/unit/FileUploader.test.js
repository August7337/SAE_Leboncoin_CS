import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import FileUploader from '@/components/FileUploader.vue'

// ── URL mock ──────────────────────────────────────────────────────────────────
const mockCreateObjectURL = vi.fn((file) => `blob:mock/${file.name}`)
const mockRevokeObjectURL = vi.fn()
vi.stubGlobal('URL', {
  createObjectURL: mockCreateObjectURL,
  revokeObjectURL: mockRevokeObjectURL,
})

// ── Helpers ──────────────────────────────────────────────────────────────────
function makeFile(name = 'photo.jpg', type = 'image/jpeg', sizeMB = 1) {
  const blob = new Blob([new ArrayBuffer(sizeMB * 1024 * 1024)], { type })
  Object.defineProperty(blob, 'name', { value: name })
  return blob
}

function mountUploader(props = {}) {
  return mount(FileUploader, {
    props: {
      modelValue: [],
      accept: 'image/jpeg, image/png, image/webp',
      maxSizeMB: 10,
      ...props,
    },
  })
}

// ── Tests ─────────────────────────────────────────────────────────────────────
describe('FileUploader.vue', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  // ── Rendu ────────────────────────────────────────────────────────────────
  describe('Rendu initial', () => {
    it('affiche la zone de dépôt', () => {
      const wrapper = mountUploader()
      expect(wrapper.text()).toContain('Cliquez ou glissez vos photos ici')
    })

    it("affiche la taille max en MB", () => {
      const wrapper = mountUploader({ maxSizeMB: 5 })
      expect(wrapper.text()).toContain('5 MB')
    })

    it("n'affiche pas de grille si aucun fichier n'est sélectionné", () => {
      const wrapper = mountUploader()
      expect(wrapper.findAll('img')).toHaveLength(0)
    })
  })

  // ── processFiles ─────────────────────────────────────────────────────────
  describe('processFiles()', () => {
    it('accepte les fichiers image valides', async () => {
      const wrapper = mountUploader()
      const file = makeFile('a.jpg', 'image/jpeg', 1)
      await wrapper.vm.processFiles([file])
      expect(wrapper.vm.files).toHaveLength(1)
    })

    it('rejette les fichiers dont le type ne commence pas par image/', async () => {
      const wrapper = mountUploader()
      const file = makeFile('doc.pdf', 'application/pdf', 1)
      await wrapper.vm.processFiles([file])
      expect(wrapper.vm.files).toHaveLength(0)
    })

    it('rejette les fichiers dépassant maxSizeMB', async () => {
      const wrapper = mountUploader({ maxSizeMB: 2 })
      const file = makeFile('big.jpg', 'image/jpeg', 5)
      await wrapper.vm.processFiles([file])
      expect(wrapper.vm.files).toHaveLength(0)
    })

    it('accepte un fichier exactement à la limite de taille', async () => {
      const wrapper = mountUploader({ maxSizeMB: 2 })
      const file = makeFile('exact.jpg', 'image/jpeg', 2)
      await wrapper.vm.processFiles([file])
      expect(wrapper.vm.files).toHaveLength(1)
    })

    it('accumule les fichiers à chaque appel', async () => {
      const wrapper = mountUploader()
      await wrapper.vm.processFiles([makeFile('a.jpg')])
      await wrapper.vm.processFiles([makeFile('b.jpg')])
      expect(wrapper.vm.files).toHaveLength(2)
    })

    it('crée un aperçu via URL.createObjectURL pour chaque fichier valide', async () => {
      const wrapper = mountUploader()
      const file = makeFile('photo.jpg')
      await wrapper.vm.processFiles([file])
      expect(mockCreateObjectURL).toHaveBeenCalledWith(file)
      expect(wrapper.vm.files[0].preview).toContain('blob:mock/')
    })

    it("émet 'update:modelValue' avec les fichiers bruts", async () => {
      const wrapper = mountUploader()
      const file = makeFile('photo.jpg')
      await wrapper.vm.processFiles([file])
      expect(wrapper.emitted('update:modelValue')).toBeTruthy()
      expect(wrapper.emitted('update:modelValue')[0][0]).toContain(file)
    })

    it('filtre silencieusement les fichiers invalides sans erreur', async () => {
      const wrapper = mountUploader({ maxSizeMB: 5 })
      const valid = makeFile('good.jpg', 'image/jpeg', 1)
      const invalid = makeFile('bad.pdf', 'application/pdf', 1)
      await wrapper.vm.processFiles([valid, invalid])
      expect(wrapper.vm.files).toHaveLength(1)
    })
  })

  // ── removeFile ───────────────────────────────────────────────────────────
  describe('removeFile()', () => {
    it('retire le fichier à l\'index donné', async () => {
      const wrapper = mountUploader()
      await wrapper.vm.processFiles([makeFile('a.jpg'), makeFile('b.jpg')])
      wrapper.vm.removeFile(0)
      expect(wrapper.vm.files).toHaveLength(1)
      expect(wrapper.vm.files[0].file.name).toBe('b.jpg')
    })

    it('révoque l\'URL de prévisualisation', async () => {
      const wrapper = mountUploader()
      const file = makeFile('a.jpg')
      await wrapper.vm.processFiles([file])
      const preview = wrapper.vm.files[0].preview
      wrapper.vm.removeFile(0)
      expect(mockRevokeObjectURL).toHaveBeenCalledWith(preview)
    })

    it("émet 'update:modelValue' après suppression", async () => {
      const wrapper = mountUploader()
      await wrapper.vm.processFiles([makeFile('a.jpg'), makeFile('b.jpg')])
      vi.clearAllMocks()
      wrapper.vm.removeFile(0)
      expect(wrapper.emitted('update:modelValue')).toBeTruthy()
    })
  })

  // ── handleDrop ───────────────────────────────────────────────────────────
  describe('handleDrop()', () => {
    it('remet isDragging à false', async () => {
      const wrapper = mountUploader()
      wrapper.vm.isDragging = true
      const file = makeFile('drop.jpg')
      await wrapper.vm.handleDrop({
        dataTransfer: { files: [file] },
      })
      expect(wrapper.vm.isDragging).toBe(false)
    })

    it('traite les fichiers droppés', async () => {
      const wrapper = mountUploader()
      const file = makeFile('drop.jpg')
      await wrapper.vm.handleDrop({ dataTransfer: { files: [file] } })
      expect(wrapper.vm.files).toHaveLength(1)
      expect(wrapper.emitted('update:modelValue')).toBeTruthy()
      expect(wrapper.emitted('update:modelValue')[0][0]).toEqual([file])
    })

    it('ne plante pas si dataTransfer.files est absent', () => {
      const wrapper = mountUploader()
      expect(() => wrapper.vm.handleDrop({ dataTransfer: {} })).not.toThrow()
    })
  })

  // ── Watcher modelValue ───────────────────────────────────────────────────
  describe('Watcher sur modelValue', () => {
    it('réinitialise les fichiers quand modelValue est vidé à []', async () => {
      const wrapper = mountUploader()
      await wrapper.vm.processFiles([makeFile('a.jpg')])
      expect(wrapper.vm.files).toHaveLength(1)
      await wrapper.setProps({ modelValue: [] })
      expect(wrapper.vm.files).toHaveLength(0)
    })

    it('révoque les URLs existantes lors du reset', async () => {
      const wrapper = mountUploader()
      await wrapper.vm.processFiles([makeFile('a.jpg')])
      vi.clearAllMocks()
      await wrapper.setProps({ modelValue: [] })
      expect(mockRevokeObjectURL).toHaveBeenCalledTimes(1)
    })

    it("ne réinitialise pas si modelValue est non vide", async () => {
      const wrapper = mountUploader()
      await wrapper.vm.processFiles([makeFile('a.jpg'), makeFile('b.jpg')])
      await wrapper.setProps({ modelValue: [makeFile('a.jpg')] })
      // Should still have both local files — watcher only fires on length === 0
      expect(wrapper.vm.files).toHaveLength(2)
    })
  })

  // ── drag state ───────────────────────────────────────────────────────────
  describe('État de drag', () => {
    it('passe isDragging à true sur dragover', async () => {
      const wrapper = mountUploader()
      const zone = wrapper.find('[class*="border-dashed"]')
      await zone.trigger('dragover')
      expect(wrapper.vm.isDragging).toBe(true)
    })

    it('passe isDragging à false sur dragleave', async () => {
      const wrapper = mountUploader()
      wrapper.vm.isDragging = true
      const zone = wrapper.find('[class*="border-dashed"]')
      await zone.trigger('dragleave')
      expect(wrapper.vm.isDragging).toBe(false)
    })
  })
})
