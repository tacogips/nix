{ lib, ... }:

let
  skillRoot = ./.;
in
{
  home.activation.appleGatewaySkill = lib.hm.dag.entryAfter [ "codexSkills" ] ''
    skill_dir="$HOME/.agents/skills/apple-gateway"

    install_skill_file() {
      local source_path="$1"
      local target_path="$2"
      local target_dir

      target_dir="$(dirname "$target_path")"
      mkdir -p "$target_dir"

      if [ -L "$target_path" ] || [ -e "$target_path" ]; then
        rm -f "$target_path"
      fi

      cp "$source_path" "$target_path"
    }

    install_skill_file \
      "${skillRoot}/SKILL.md" \
      "$skill_dir/SKILL.md"
    install_skill_file \
      "${skillRoot}/agents/openai.yaml" \
      "$skill_dir/agents/openai.yaml"
  '';
}
