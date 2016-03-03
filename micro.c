// This is a super sketchy program for stripping sections
// from the executable while leaving the single program
// header section. It is used to reduce the size of the
// executables produced by the linker and assembler.

#include <elf.h>
#include <stdio.h>

#define REQUIRE(x) if (!(x)) {                  \
    printf("requirement " #x " not met\n");     \
    return 100;                                 \
  }

int main(int argc, char **argv) {
  REQUIRE(argc == 3);

  FILE *ifp = fopen(argv[1], "rb");
  Elf64_Ehdr hdr;
  Elf64_Phdr phdr;

  // Read in the main header
  fread(&hdr, sizeof(Elf64_Ehdr), 1, ifp);
  REQUIRE(hdr.e_ident[EI_CLASS] == ELFCLASS64);
  REQUIRE(hdr.e_ident[EI_DATA] == ELFDATA2LSB);
  REQUIRE(hdr.e_phnum == 1);
  REQUIRE(hdr.e_phoff == sizeof(Elf64_Ehdr));

  // Pretend like there are no sections in the file (as there won't be)
  hdr.e_shnum = 0;
  hdr.e_shstrndx = 0;
  hdr.e_shoff = 0;

  // Read in the program header
  fread(&phdr, sizeof(Elf64_Phdr), 1, ifp);
  REQUIRE(phdr.p_offset == 0);

  // Read in the rest of the file
  Elf64_Xword seg_size = phdr.p_filesz - sizeof(hdr) - sizeof(phdr);
  char buf[seg_size];
  fread(&buf, seg_size, 1, ifp);
  fclose(ifp);

  // Write out the file
  FILE *ofp = fopen(argv[2], "wb");
  fwrite(&hdr, sizeof(hdr), 1, ofp);
  fwrite(&phdr, sizeof(phdr), 1, ofp);
  fwrite(&buf, seg_size, 1, ofp);
  fclose(ofp);

  printf(":: Wrote %s - %ld bytes (%ld bytes code)\n",
         argv[2], phdr.p_filesz, seg_size);
  return 0;
}
