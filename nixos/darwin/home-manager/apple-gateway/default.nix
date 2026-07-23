{ lib, ... }:

let
  skillRoot = ./.;
  domainSkillNames = [
    "apple-calendar"
    "apple-clock-alarms"
    "apple-mail"
    "apple-notes"
    "apple-notifications"
    "apple-reminders"
    "apple-schedule"
  ];
  installDomainSkills = lib.concatMapStringsSep "\n" (skillName: ''
    install_skill_file \
      "${skillRoot}/skills/${skillName}/SKILL.md" \
      "$skills_dir/${skillName}/SKILL.md"
    install_skill_file \
      "${skillRoot}/skills/${skillName}/agents/openai.yaml" \
      "$skills_dir/${skillName}/agents/openai.yaml"
  '') domainSkillNames;
in
{
  home.activation.appleGatewaySkill = lib.hm.dag.entryAfter [ "codexSkills" ] ''
    skills_dir="$HOME/.agents/skills"

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
      "$skills_dir/apple-gateway/SKILL.md"
    install_skill_file \
      "${skillRoot}/agents/openai.yaml" \
      "$skills_dir/apple-gateway/agents/openai.yaml"

    ${installDomainSkills}
  '';
}
