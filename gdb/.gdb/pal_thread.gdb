define print_tnode
  set $id = $arg0->handle
  set $name = $arg0->name
  set $tid = $arg0->tid
#  set $state = $arg0->state
#  set $reason = $arg0->sleep_reason
  set $prio = $arg0->priority
  set $sbase = $arg0->stack_base
  set $ssize = $arg0->stack_size

  if ($name == 0)
      printf "0x%08x %08d                        ", $id, $tid
  else
      printf "0x%08x %08d  %-20.20s  ", $id, $tid, $name
  end
#  print_state $state $reason
## printf " %02d ", arm_mmu_get_domain($arg0->stack_base)
  printf " %02d    0x%08x  %d\n", $prio, $sbase, $ssize
  printf "\n"
end

define pal_posix_tl
  printf "ID         tid       Name                   Prio  Stack base  Stack size\n"
  printf "------------------------------------------------------------------------------\n"
  set $node = thread_db_head
  while ( $node != 0 )
    print_tnode $node
    set $node = $node->next
  end
  printf "gdb_ID    (ID)        tid          Address\n"
  printf "------------------------------------------------------------------------------\n"
  info thread
  printf "------------------------------------------------------------------------------\n"
  printf "The thread gdb_ID == 1 is the pal 'alarm dsr thread'\n"
  printf "use 'thread gdb_ID' to switch thread context.\n"
end

#add in another file if possible
handle SIGUSR2 noprint
