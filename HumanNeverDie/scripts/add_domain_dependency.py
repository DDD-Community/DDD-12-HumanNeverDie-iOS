#!/usr/bin/env python3
# scripts/add_domain_dependency.py

import sys
import re

def add_domain_dependency(file_path, domain_name):
    with open(file_path, 'r') as file:
        content = file.read()
    
    # dependencies 배열 찾기
    pattern = r'(dependencies:\s*\[)(.*?)(\])'
    match = re.search(pattern, content, re.DOTALL)
    
    if match:
        dependencies = match.group(2).strip()
        
        # 이미 있는지 확인
        if f'.domain(module: .{domain_name})' in content:
            print(f"⚠️  {domain_name} already exists in BaseDomain dependencies")
            return
        
        # 새 의존성 추가
        if dependencies:
            # 마지막에 쉼표 추가
            new_dependencies = dependencies.rstrip() + ',\n        .domain(module: .' + domain_name + ')'
        else:
            new_dependencies = '\n        .domain(module: .' + domain_name + ')'
        
        # 파일 업데이트
        new_content = content[:match.start(2)] + new_dependencies + '\n    ' + content[match.end(2):]
        
        with open(file_path, 'w') as file:
            file.write(new_content)
        
        print(f"✅ Added {domain_name} to BaseDomain dependencies")
    else:
        print("❌ Could not find dependencies array in BaseDomain")

def add_domain_to_modules(domain_name):
    """Modules.swift에 새로운 Domain enum case 추가"""
    modules_file_path = "Tuist/ProjectDescriptionHelpers/Module/Modules.swift"
    
    with open(modules_file_path, 'r') as file:
        content = file.read()
    
    # Domain enum 찾기
    pattern = r'(enum Domain: String \{)(.*?)(\n\s+var name: String)'
    match = re.search(pattern, content, re.DOTALL)
    
    if match:
        cases = match.group(2).strip()
        
        # 이미 있는지 확인
        if f'case {domain_name}' in cases:
            print(f"⚠️  {domain_name} already exists in Modules.Domain")
            return
        
        # 새 case 추가
        new_cases = cases + f'\n        case {domain_name}'
        
        # 파일 업데이트
        new_content = content[:match.start(2)] + new_cases + '\n    ' + content[match.end(2):]
        
        with open(modules_file_path, 'w') as file:
            file.write(new_content)
        
        print(f"✅ Added {domain_name} to Modules.Domain enum")
    else:
        print("❌ Could not find Domain enum in Modules.swift")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python add_domain_dependency.py <domain_name>")
        sys.exit(1)
    
    domain_name = sys.argv[1]
    base_domain_file_path = "Projects/Domain/BaseDomain/Project.swift"
    
    # Modules.swift에 Domain enum case 추가
    add_domain_to_modules(domain_name)
    
    # BaseDomain에 의존성 추가
    add_domain_dependency(base_domain_file_path, domain_name) 