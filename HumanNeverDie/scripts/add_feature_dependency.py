#!/usr/bin/env python3
# scripts/add_feature_dependency.py

import sys
import re

def add_feature_dependency(file_path, feature_name):
    with open(file_path, 'r') as file:
        content = file.read()
    
    # dependencies 배열 찾기
    pattern = r'(dependencies:\s*\[)(.*?)(\])'
    match = re.search(pattern, content, re.DOTALL)
    
    if match:
        dependencies = match.group(2).strip()
        
        # 이미 있는지 확인
        if f'.feature(module: .{feature_name})' in content:
            print(f"⚠️  {feature_name} already exists")
            return
        
        # 새 의존성 추가
        if dependencies:
            # 마지막에 쉼표 추가
            new_dependencies = dependencies.rstrip() + ',\n        .feature(module: .' + feature_name + ')'
        else:
            new_dependencies = '\n        .feature(module: .' + feature_name + ')'
        
        # 파일 업데이트
        new_content = content[:match.start(2)] + new_dependencies + '\n    ' + content[match.end(2):]
        
        with open(file_path, 'w') as file:
            file.write(new_content)
        
        print(f"✅ Added {feature_name} to dependencies")
    else:
        print("❌ Could not find dependencies array")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python add_feature_dependency.py <feature_name>")
        sys.exit(1)
    
    feature_name = sys.argv[1]
    file_path = "Projects/RootFeature/Project.swift"
    
    add_feature_dependency(file_path, feature_name)
