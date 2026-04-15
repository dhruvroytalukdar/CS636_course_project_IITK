import re

def parse_tsan_log(filepath):
    """Extracts a set of line numbers where TSAN reported a race."""
    tsan_lines = set()
    
    pattern = re.compile(r'#0 .*?:(\d+)(?::\d+)?')
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            for line in f:
                match = pattern.search(line)
                if match:
                    tsan_lines.add(int(match.group(1)))
    except FileNotFoundError:
        pass
    return tsan_lines

def parse_ft_log(filepath):
    """Extracts line numbers directly from the new FastTrack logs."""
    ft_lines = set()

    pattern = re.compile(r'LINE:\s*(\d+)')
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            for line in f:
                match = pattern.search(line)
                if match:
                    ft_lines.add(int(match.group(1)))
    except FileNotFoundError:
        pass
    return ft_lines

def main():
    # 1. Parse all three logs directly (No LLVM IR translation needed anymore!)
    tsan_races = parse_tsan_log("out_tsan.txt")
    ft_races = parse_ft_log("out_ft.txt")
    sa_races = parse_ft_log("out_sa.txt")
    
    # 2. Print the Automated Report
    print(f"\n{'='*40}")
    print(" AUTOMATED VALIDATION REPORT")
    print(f"{'='*40}")
    
    print(f"TSAN Baseline flagged lines     : {sorted(list(tsan_races))}")
    print(f"Plain FT flagged lines          : {sorted(list(ft_races))}")
    print(f"Sharing Analysis flagged lines  : {sorted(list(sa_races))}\n")
    
    # Check if all TSAN races are caught by Plain FastTrack
    missing_in_ft = tsan_races - ft_races
    if not missing_in_ft:
        print("[PASS] Plain FastTrack caught all TSAN race locations.")
    else:
        print(f"[FAIL] Plain FastTrack missed TSAN races on lines: {missing_in_ft}")
        
    # Verify SA FT
    missing_in_sa = tsan_races - sa_races
    if not missing_in_sa:
        print("[PASS] SA + FastTrack caught all TSAN race locations.")
    else:
        print(f"[FAIL] SA + FastTrack missed TSAN races on lines: {missing_in_sa}")
        
    print(f"{'='*40}\n")

if __name__ == "__main__":
    main()